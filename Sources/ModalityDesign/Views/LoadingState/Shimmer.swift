import SwiftUI

public struct Shimmer: View {
  
  private let startingPoint: Alignment
  
  public init(startingPoint: Alignment) {
    self.startingPoint = startingPoint
  }
  
  @State private var phase: CGFloat = 0
  
  private var gradientPoints: (start: UnitPoint, end: UnitPoint) {
    let (startX, endX) = gradientX(for: startingPoint.horizontal)
    let (startY, endY) = gradientY(for: startingPoint.vertical)
    return (UnitPoint(x: startX, y: startY), UnitPoint(x: endX, y: endY))
  }
  
  private func gradientX(for direction: HorizontalAlignment) -> (CGFloat, CGFloat) {
    switch direction {
    case .leading: return (phase - 1, phase)
    case .trailing: return (2 - phase, 1 - phase)
    default: return (0.5, 0.5)
    }
  }
  
  private func gradientY(for direction: VerticalAlignment) -> (CGFloat, CGFloat) {
    switch direction {
    case .top: return (phase - 1, phase)
    case .bottom: return (2 - phase, 1 - phase)
    default: return (0.5, 0.5)
    }
  }
  
  public var body: some View {
    GeometryReader { geometry in
      LinearGradient(
        gradient: Gradient(colors: [.clear, .white.opacity(phase.lerp(from: 0, to: 0.5)), .clear]),
        startPoint: gradientPoints.start,
        endPoint: gradientPoints.end
      )
      .blendMode(.overlay)
    }
    .onAppear {
      withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
        phase = 2
      }
    }
  }
}
