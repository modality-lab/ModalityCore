import ModalityCore
import SwiftUI

#if DEBUG
public struct DebugPerformanceHUD: View {
  @ObservedObject private var metrics: DebugRenderMetrics
  @State private var fpsHistory: [Double] = []
  @State private var lastFPSHistoryUpdate: Date?

  private let maximumFPSHistoryCount = 40
  private let fpsHistoryMinimumInterval: TimeInterval = 0.25

  @MainActor
  public init() {
    self.metrics = .shared
  }

  public init(metrics: DebugRenderMetrics) {
    self.metrics = metrics
  }

  public var body: some View {
    let snapshot = metrics.snapshot
    let averageFPS = averageFPS(fallback: snapshot.fps)

    VStack(alignment: .leading, spacing: 6) {
      HStack(alignment: .top, spacing: 8) {
        VStack(alignment: .leading, spacing: 0) {
          Text("FPS")
            .font(.system(size: 8, weight: .semibold))
            .foregroundStyle(.white.opacity(0.46))
          Text(wholeNumber(snapshot.fps))
            .font(.system(size: 20, weight: .semibold, design: .rounded))
            .monospacedDigit()
        }

        Spacer(minLength: 0)

        VStack(alignment: .trailing, spacing: 2) {
          inlineMetric("avg", value: wholeNumber(averageFPS))
          inlineMetric("max", value: "\(wholeNumber(snapshot.displayHz))Hz")
        }
        .padding(.top, 1)
      }

      fpsSparkline(samples: fpsHistory, averageFPS: averageFPS)

      HStack(alignment: .firstTextBaseline, spacing: 9) {
        compactMetric("ms", value: millisecondsNumber(snapshot.latestFrameDuration))
        compactMetric("p95", value: millisecondsNumber(snapshot.p95FrameDuration))
        compactMetric("max", value: millisecondsNumber(snapshot.worstFrameDuration))
        compactMetric(
          "hitch",
          value: "\(snapshot.hitchCount)",
          valueColor: snapshot.hitchCount == 0 ? .white.opacity(0.86) : .orange
        )
      }
    }
    .frame(width: 164)
    .foregroundStyle(.white)
    .lineLimit(1)
    .padding(.horizontal, 8)
    .padding(.vertical, 7)
    .background(.black.opacity(0.58), in: RoundedRectangle(cornerRadius: 7, style: .continuous))
    .overlay {
      RoundedRectangle(cornerRadius: 7, style: .continuous)
        .stroke(.white.opacity(0.12), lineWidth: 1)
    }
    .shadow(color: .black.opacity(0.16), radius: 4, y: 2)
    .fixedSize(horizontal: true, vertical: false)
    .accessibilityHidden(true)
    .onAppear {
      appendFPS(snapshot.fps, force: true)
    }
    .onChange(of: snapshot) { newSnapshot in
      appendFPS(newSnapshot.fps)
    }
  }

  private func inlineMetric(_ title: String, value: String) -> some View {
    HStack(alignment: .firstTextBaseline, spacing: 4) {
      Text(title.uppercased())
        .font(.system(size: 7, weight: .semibold))
        .foregroundStyle(.white.opacity(0.42))
      Text(value)
        .font(.system(size: 9, weight: .semibold, design: .monospaced))
        .monospacedDigit()
    }
  }

  private func compactMetric(_ title: String, value: String, valueColor: Color = .white.opacity(0.86)) -> some View {
    VStack(alignment: .leading, spacing: 1) {
      Text(title.uppercased())
        .font(.system(size: 7, weight: .semibold))
        .foregroundStyle(.white.opacity(0.42))
      Text(value)
        .font(.system(size: 9, weight: .semibold, design: .monospaced))
        .monospacedDigit()
        .foregroundStyle(valueColor)
    }
  }

  private func fpsSparkline(samples: [Double], averageFPS: Double) -> some View {
    let graphSamples = samples.isEmpty ? [averageFPS] : samples
    let minimumFPS = graphSamples.min() ?? averageFPS
    let maximumFPS = graphSamples.max() ?? averageFPS
    let visibleSpan = max(maximumFPS - minimumFPS, 4)
    let midpoint = (minimumFPS + maximumFPS) / 2
    let lowerBound = max(0, midpoint - visibleSpan / 2)
    let upperBound = max(lowerBound + 1, midpoint + visibleSpan / 2)

    return Canvas { context, size in
      let verticalInset: CGFloat = 3
      let drawableHeight = max(size.height - verticalInset * 2, 1)
      let clamped = graphSamples.map { sample in
        min(max((sample - lowerBound) / (upperBound - lowerBound), 0), 1)
      }
      let denominator = CGFloat(max(clamped.count - 1, 1))
      let points = clamped.enumerated().map { index, value in
        CGPoint(
          x: CGFloat(index) / denominator * size.width,
          y: verticalInset + (1 - CGFloat(value)) * drawableHeight
        )
      }

      let averagePosition = min(max((averageFPS - lowerBound) / (upperBound - lowerBound), 0), 1)
      let averageY = verticalInset + (1 - CGFloat(averagePosition)) * drawableHeight
      var averageLine = Path()
      averageLine.move(to: CGPoint(x: 0, y: averageY))
      averageLine.addLine(to: CGPoint(x: size.width, y: averageY))
      context.stroke(
        averageLine,
        with: .color(.white.opacity(0.10)),
        style: StrokeStyle(lineWidth: 1, dash: [2, 3])
      )

      guard let firstPoint = points.first else { return }

      var line = Path()
      line.move(to: firstPoint)
      for point in points.dropFirst() {
        line.addLine(to: point)
      }

      var fill = line
      fill.addLine(to: CGPoint(x: size.width, y: size.height))
      fill.addLine(to: CGPoint(x: 0, y: size.height))
      fill.closeSubpath()

      context.fill(
        fill,
        with: .linearGradient(
          Gradient(colors: [.purple.opacity(0.22), .purple.opacity(0.01)]),
          startPoint: CGPoint(x: 0, y: 0),
          endPoint: CGPoint(x: 0, y: size.height)
        )
      )
      context.stroke(
        line,
        with: .color(.purple.opacity(0.94)),
        style: StrokeStyle(lineWidth: 1.25, lineCap: .round, lineJoin: .round)
      )
    }
    .frame(height: 18)
    .background(.white.opacity(0.035), in: RoundedRectangle(cornerRadius: 4, style: .continuous))
  }

  private func millisecondsNumber(_ duration: TimeInterval) -> String {
    String(format: "%.1f", duration * 1000)
  }

  private func wholeNumber(_ value: Double) -> String {
    String(format: "%.0f", value)
  }

  private func averageFPS(fallback: Double) -> Double {
    guard !fpsHistory.isEmpty else {
      return fallback
    }
    return fpsHistory.reduce(0, +) / Double(fpsHistory.count)
  }

  private func appendFPS(_ fps: Double, force: Bool = false) {
    guard fps.isFinite, fps >= 0 else {
      return
    }

    let now = Date()
    if !force, let lastFPSHistoryUpdate, now.timeIntervalSince(lastFPSHistoryUpdate) < fpsHistoryMinimumInterval {
      return
    }

    lastFPSHistoryUpdate = now
    fpsHistory.append(fps)
    if fpsHistory.count > maximumFPSHistoryCount {
      fpsHistory.removeFirst(fpsHistory.count - maximumFPSHistoryCount)
    }
  }
}

private struct DebugPerformanceOverlayModifier: ViewModifier {
  let enabled: Bool
  @ObservedObject private var metrics: DebugRenderMetrics

  init(enabled: Bool, metrics: DebugRenderMetrics) {
    self.enabled = enabled
    self.metrics = metrics
  }

  func body(content: Content) -> some View {
    if enabled {
      content
        .overlay(alignment: .topTrailing) {
          DebugPerformanceHUD(metrics: metrics)
            .padding(.top, 6)
            .padding(.trailing, 6)
            .allowsHitTesting(false)
        }
        .onAppear {
          metrics.startSampling()
        }
        .onDisappear {
          metrics.stopSampling()
        }
    } else {
      content
    }
  }
}
#endif

public extension View {
  @MainActor
  @ViewBuilder
  func debugPerformanceOverlay(enabled: Bool = true) -> some View {
    #if DEBUG
    modifier(DebugPerformanceOverlayModifier(enabled: enabled, metrics: .shared))
    #else
    self
    #endif
  }
}
