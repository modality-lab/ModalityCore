import Combine
import Foundation

#if DEBUG
#if os(iOS) || os(visionOS)
import QuartzCore
#if os(iOS)
import UIKit
#endif
#elseif os(macOS)
import AppKit
import CoreVideo
#endif
#endif

@MainActor
public final class DebugRenderMetrics: ObservableObject {
  public static let shared = DebugRenderMetrics()

  @Published public private(set) var snapshot: DebugRenderMetricsSnapshot = .empty

  #if DEBUG
  private var aggregator = DebugRenderMetricsAggregator()
  private var activeConsumers = 0
  private var lastPublishTime: TimeInterval = 0
  private let publishInterval: TimeInterval
  private var sampler: (any DisplayFrameSampling)?

  public init(publishInterval: TimeInterval = 0.25) {
    self.publishInterval = publishInterval
  }

  public func startSampling() {
    activeConsumers += 1
    guard activeConsumers == 1 else { return }

    sampler = makeDisplayFrameSampler { [weak self] timestamp, displayHz in
      self?.recordFrame(timestamp: timestamp, displayHz: displayHz)
    }
    sampler?.start()
    publishSnapshot(now: ProcessInfo.processInfo.systemUptime, force: true)
  }

  public func stopSampling() {
    guard activeConsumers > 0 else { return }

    activeConsumers -= 1
    guard activeConsumers == 0 else { return }

    sampler?.stop()
    sampler = nil
  }

  private func recordFrame(timestamp: TimeInterval, displayHz: Double) {
    aggregator.recordFrame(timestamp: timestamp, displayHz: displayHz)
    publishSnapshot(now: timestamp, force: false)
  }

  private func publishSnapshot(now: TimeInterval, force: Bool) {
    guard force || now - lastPublishTime >= publishInterval else { return }

    snapshot = aggregator.snapshot(now: now)
    lastPublishTime = now
  }
  #else
  public init() {}

  public func startSampling() {}
  public func stopSampling() {}
  #endif
}

#if DEBUG
@MainActor
private protocol DisplayFrameSampling: AnyObject {
  func start()
  func stop()
}

@MainActor
private func makeDisplayFrameSampler(
  onFrame: @escaping @MainActor (TimeInterval, Double) -> Void
) -> any DisplayFrameSampling {
  #if os(iOS) || os(visionOS)
  CADisplayFrameSampler(onFrame: onFrame)
  #elseif os(macOS)
  MacDisplayFrameSampler(onFrame: onFrame)
  #else
  TimerDisplayFrameSampler(displayHz: 60, onFrame: onFrame)
  #endif
}

#if os(iOS) || os(visionOS)
@MainActor
private final class CADisplayFrameSampler: NSObject, DisplayFrameSampling {
  private let onFrame: @MainActor (TimeInterval, Double) -> Void
  private var displayLink: CADisplayLink?

  init(onFrame: @escaping @MainActor (TimeInterval, Double) -> Void) {
    self.onFrame = onFrame
  }

  func start() {
    stop()

    let displayLink = CADisplayLink(target: self, selector: #selector(displayLinkDidFire(_:)))
    displayLink.add(to: .main, forMode: .common)
    self.displayLink = displayLink
  }

  func stop() {
    displayLink?.invalidate()
    displayLink = nil
  }

  @objc private func displayLinkDidFire(_ displayLink: CADisplayLink) {
    let durationHz = displayLink.duration > 0 ? 1 / displayLink.duration : 0
    #if os(iOS)
    let screenHz = Double(UIScreen.main.maximumFramesPerSecond)
    #else
    let screenHz = durationHz
    #endif
    onFrame(displayLink.timestamp, max(durationHz, screenHz))
  }
}
#elseif os(macOS)
@MainActor
private final class MacDisplayFrameSampler: DisplayFrameSampling {
  private let onFrame: @MainActor (TimeInterval, Double) -> Void
  private var displayLink: CVDisplayLink?
  private var callbackTarget: MacDisplayLinkCallbackTarget?
  private var fallbackSampler: TimerDisplayFrameSampler?

  init(onFrame: @escaping @MainActor (TimeInterval, Double) -> Void) {
    self.onFrame = onFrame
  }

  func start() {
    stop()

    var displayLink: CVDisplayLink?
    guard CVDisplayLinkCreateWithActiveCGDisplays(&displayLink) == kCVReturnSuccess,
          let displayLink
    else {
      startFallbackSampler()
      return
    }

    let callbackTarget = MacDisplayLinkCallbackTarget(
      displayHz: Self.currentDisplayHz(),
      onFrame: onFrame
    )
    let context = Unmanaged.passUnretained(callbackTarget).toOpaque()

    let callback: CVDisplayLinkOutputCallback = { _, _, _, _, _, context in
      guard let context else { return kCVReturnSuccess }

      let target = Unmanaged<MacDisplayLinkCallbackTarget>
        .fromOpaque(context)
        .takeUnretainedValue()
      target.displayLinkDidFire()
      return kCVReturnSuccess
    }

    guard CVDisplayLinkSetOutputCallback(displayLink, callback, context) == kCVReturnSuccess,
          CVDisplayLinkStart(displayLink) == kCVReturnSuccess
    else {
      startFallbackSampler()
      return
    }

    self.displayLink = displayLink
    self.callbackTarget = callbackTarget
  }

  func stop() {
    if let displayLink {
      CVDisplayLinkStop(displayLink)
    }

    displayLink = nil
    callbackTarget = nil
    fallbackSampler?.stop()
    fallbackSampler = nil
  }

  private func startFallbackSampler() {
    let fallbackSampler = TimerDisplayFrameSampler(
      displayHz: Self.currentDisplayHz(),
      onFrame: onFrame
    )
    fallbackSampler.start()
    self.fallbackSampler = fallbackSampler
  }

  private static func currentDisplayHz() -> Double {
    let screenHz = NSScreen.main?.maximumFramesPerSecond ?? 60
    return Double(max(screenHz, 1))
  }
}

private final class MacDisplayLinkCallbackTarget: @unchecked Sendable {
  private let lock = NSLock()
  private let displayHz: Double
  private let onFrame: @MainActor (TimeInterval, Double) -> Void
  private var isFrameDeliveryPending = false

  init(displayHz: Double, onFrame: @escaping @MainActor (TimeInterval, Double) -> Void) {
    self.displayHz = displayHz
    self.onFrame = onFrame
  }

  func displayLinkDidFire() {
    guard markFrameDeliveryPending() else { return }

    Task { @MainActor [weak self] in
      self?.deliverFrameOnMainActor()
    }
  }

  private func markFrameDeliveryPending() -> Bool {
    lock.lock()
    defer { lock.unlock() }

    guard !isFrameDeliveryPending else { return false }

    isFrameDeliveryPending = true
    return true
  }

  @MainActor
  private func deliverFrameOnMainActor() {
    let timestamp = ProcessInfo.processInfo.systemUptime
    onFrame(timestamp, displayHz)
    clearFrameDeliveryPending()
  }

  private func clearFrameDeliveryPending() {
    lock.lock()
    isFrameDeliveryPending = false
    lock.unlock()
  }
}
#endif

@MainActor
private final class TimerDisplayFrameSampler: DisplayFrameSampling {
  private let displayHz: Double
  private let onFrame: @MainActor (TimeInterval, Double) -> Void
  private var timer: Timer?

  init(displayHz: Double, onFrame: @escaping @MainActor (TimeInterval, Double) -> Void) {
    self.displayHz = max(displayHz, 1)
    self.onFrame = onFrame
  }

  func start() {
    stop()

    timer = Timer.scheduledTimer(withTimeInterval: 1 / displayHz, repeats: true) { [weak self] _ in
      Task { @MainActor in
        self?.onFrame(ProcessInfo.processInfo.systemUptime, self?.displayHz ?? 60)
      }
    }
  }

  func stop() {
    timer?.invalidate()
    timer = nil
  }
}
#endif
