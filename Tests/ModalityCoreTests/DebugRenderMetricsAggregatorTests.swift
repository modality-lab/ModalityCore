import Foundation
import Testing
import ModalityCore

struct DebugRenderMetricsAggregatorTests {
  @Test
  func stableSixtyHertzFrames() {
    var aggregator = DebugRenderMetricsAggregator(displayHz: 60)

    for index in 0...60 {
      aggregator.recordFrame(timestamp: Double(index) / 60, displayHz: 60)
    }

    let snapshot = aggregator.snapshot(now: 1)

    #expect(snapshot.displayHz == 60)
    #expect(abs(snapshot.frameCadenceHz - 60) < 0.000_1)
    #expect(snapshot.fps == 60)
    #expect(snapshot.hitchCount == 0)
    #expect(abs(snapshot.latestFrameDuration - 1 / 60) < 0.000_000_1)
    #expect(abs(snapshot.p95FrameDuration - 1 / 60) < 0.000_000_1)
    #expect(abs(snapshot.worstFrameDuration - 1 / 60) < 0.000_000_1)
  }

  @Test
  func stableOneHundredTwentyHertzFrames() {
    var aggregator = DebugRenderMetricsAggregator(displayHz: 120)

    for index in 0...120 {
      aggregator.recordFrame(timestamp: Double(index) / 120, displayHz: 120)
    }

    let snapshot = aggregator.snapshot(now: 1)

    #expect(snapshot.displayHz == 120)
    #expect(abs(snapshot.frameCadenceHz - 120) < 0.000_1)
    #expect(snapshot.fps == 120)
    #expect(snapshot.hitchCount == 0)
    #expect(abs(snapshot.latestFrameDuration - 1 / 120) < 0.000_000_1)
  }

  @Test
  func stableSixtyFpsOnOneHundredTwentyHertzDisplayDoesNotCountHitches() {
    var aggregator = DebugRenderMetricsAggregator(displayHz: 120)

    for index in 0...60 {
      aggregator.recordFrame(timestamp: Double(index) / 60, displayHz: 120)
    }

    let snapshot = aggregator.snapshot(now: 1)

    #expect(snapshot.displayHz == 120)
    #expect(abs(snapshot.frameCadenceHz - 60) < 0.000_1)
    #expect(snapshot.fps == 60)
    #expect(snapshot.hitchCount == 0)
    #expect(abs(snapshot.latestFrameDuration - 1 / 60) < 0.000_000_1)
  }

  @Test
  func delayedFrameIncrementsHitchEstimate() {
    var aggregator = DebugRenderMetricsAggregator(displayHz: 60)

    aggregator.recordFrame(timestamp: 0, displayHz: 60)
    aggregator.recordFrame(timestamp: 1 / 60, displayHz: 60)
    aggregator.recordFrame(timestamp: 3 / 60, displayHz: 60)
    aggregator.recordFrame(timestamp: 4 / 60, displayHz: 60)

    let snapshot = aggregator.snapshot(now: 4 / 60)

    #expect(snapshot.hitchCount == 1)
    #expect(abs(snapshot.frameCadenceHz - 60) < 0.000_1)
    #expect(abs(snapshot.worstFrameDuration - 2 / 60) < 0.000_000_1)
    #expect(abs(snapshot.p95FrameDuration - 2 / 60) < 0.000_000_1)
  }

  @Test
  func rollingWindowEvictsOldFrames() {
    var aggregator = DebugRenderMetricsAggregator(frameWindow: 1)

    aggregator.recordFrame(timestamp: 0, displayHz: 60)
    aggregator.recordFrame(timestamp: 0.1, displayHz: 60)

    let snapshot = aggregator.snapshot(now: 2)

    #expect(snapshot.frameSampleCount == 0)
    #expect(snapshot.fps == 0)
  }
}
