import Foundation

public struct DebugRenderMetricsSnapshot: Equatable, Sendable {
  public static let empty = DebugRenderMetricsSnapshot(
    displayHz: 0,
    frameCadenceHz: 0,
    fps: 0,
    latestFrameDuration: 0,
    p95FrameDuration: 0,
    worstFrameDuration: 0,
    hitchCount: 0,
    frameSampleCount: 0
  )

  public let displayHz: Double
  public let frameCadenceHz: Double
  public let fps: Double
  public let latestFrameDuration: TimeInterval
  public let p95FrameDuration: TimeInterval
  public let worstFrameDuration: TimeInterval
  public let hitchCount: Int
  public let frameSampleCount: Int

  public init(
    displayHz: Double,
    frameCadenceHz: Double,
    fps: Double,
    latestFrameDuration: TimeInterval,
    p95FrameDuration: TimeInterval,
    worstFrameDuration: TimeInterval,
    hitchCount: Int,
    frameSampleCount: Int
  ) {
    self.displayHz = displayHz
    self.frameCadenceHz = frameCadenceHz
    self.fps = fps
    self.latestFrameDuration = latestFrameDuration
    self.p95FrameDuration = p95FrameDuration
    self.worstFrameDuration = worstFrameDuration
    self.hitchCount = hitchCount
    self.frameSampleCount = frameSampleCount
  }
}

public struct DebugRenderMetricsAggregator: Sendable {
  private struct FrameSample: Sendable {
    let timestamp: TimeInterval
    let duration: TimeInterval
  }

  private let frameWindow: TimeInterval

  private var lastFrameTimestamp: TimeInterval?
  private var frameSamples: [FrameSample] = []

  public private(set) var displayHz: Double

  public init(
    displayHz: Double = 60,
    frameWindow: TimeInterval = 2
  ) {
    self.displayHz = displayHz
    self.frameWindow = frameWindow
  }

  public mutating func recordFrame(timestamp: TimeInterval, displayHz: Double) {
    guard timestamp.isFinite else { return }

    if displayHz.isFinite, displayHz > 0 {
      self.displayHz = displayHz
    }

    defer {
      lastFrameTimestamp = timestamp
      pruneFrames(now: timestamp)
    }

    guard let lastFrameTimestamp, timestamp > lastFrameTimestamp else { return }

    let duration = timestamp - lastFrameTimestamp
    guard duration.isFinite, duration >= 0 else { return }

    frameSamples.append(FrameSample(timestamp: timestamp, duration: duration))
  }

  public mutating func snapshot(now: TimeInterval) -> DebugRenderMetricsSnapshot {
    guard now.isFinite else { return .empty }

    pruneFrames(now: now)

    let durations = frameSamples.map(\.duration)
    let expectedFrameDuration = expectedFrameDuration(from: durations)

    return DebugRenderMetricsSnapshot(
      displayHz: displayHz,
      frameCadenceHz: expectedFrameDuration > 0 ? 1 / expectedFrameDuration : 0,
      fps: Double(frameSamples.filter { $0.timestamp > now - 1 }.count),
      latestFrameDuration: durations.last ?? 0,
      p95FrameDuration: percentile(0.95, in: durations),
      worstFrameDuration: durations.max() ?? 0,
      hitchCount: hitchCount(
        samples: frameSamples,
        expectedFrameDuration: expectedFrameDuration
      ),
      frameSampleCount: frameSamples.count
    )
  }

  private mutating func pruneFrames(now: TimeInterval) {
    frameSamples.removeAll { $0.timestamp < now - frameWindow }
  }

  private func hitchCount(
    samples: [FrameSample],
    expectedFrameDuration: TimeInterval
  ) -> Int {
    guard expectedFrameDuration > 0 else { return 0 }

    return samples.reduce(0) { total, sample in
      guard sample.duration > expectedFrameDuration * 1.5 else { return total }

      let displayedFrameSpan = Int((sample.duration / expectedFrameDuration).rounded())
      return total + max(0, displayedFrameSpan - 1)
    }
  }

  private func expectedFrameDuration(from durations: [TimeInterval]) -> TimeInterval {
    guard !durations.isEmpty else { return displayHz > 0 ? 1 / displayHz : 1 / 60 }

    return percentile(0.5, in: durations)
  }

  private func percentile(_ percentile: Double, in values: [TimeInterval]) -> TimeInterval {
    guard !values.isEmpty else { return 0 }

    let sorted = values.sorted()
    let rawIndex = ceil(Double(sorted.count) * percentile) - 1
    let index = min(sorted.count - 1, max(0, Int(rawIndex)))
    return sorted[index]
  }
}
