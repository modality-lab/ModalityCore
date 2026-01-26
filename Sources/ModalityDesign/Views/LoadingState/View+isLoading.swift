import SwiftUI

public extension View {
  
  @ViewBuilder
  func isLoading(
    _ isLoading: Bool,
    phase: Angle = .zero,
    shimmerStartingPoint: Alignment = .leading
  ) -> some View {
    self
      .environment(\.isLoading, isLoading)
      .redacted(reason: isLoading ? .placeholder : [])
      .allowsHitTesting(!isLoading)
      .overlay {
        if isLoading {
          Shimmer(startingPoint: shimmerStartingPoint)
        }
      }
      .animation(.easeInOut(duration: 0.25), value: isLoading)
  }
}
