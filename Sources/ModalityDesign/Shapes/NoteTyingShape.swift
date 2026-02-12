import SwiftUI

public struct NoteTyingShape: Shape {
  let isFlipped: Bool
  
  public init(isFlipped: Bool = false) {
    self.isFlipped = isFlipped
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let startY = isFlipped ? rect.maxY : rect.minY
      let endY = startY
      let controlY = isFlipped ? rect.minY : rect.maxY
      path.move(to: CGPoint(x: rect.minX, y: startY))
      path.addQuadCurve(
        to: CGPoint(
          x: rect.maxX,
          y: endY
        ),
        control: CGPoint(x: rect.midX, y: controlY)
      )
    }
  }
}
