import SwiftUI

public struct RepeatShape: Shape {
  
  public enum Direction: Sendable {
    case open
    case closed
  }
  
  private let direction: Direction
  
  public init(direction: Direction) {
    self.direction = direction
  }
  
  public func path(in rect: CGRect) -> Path {
    let h = rect.height
    let w = rect.width
    
    let thinWidth = w * 0.1
    let thickWidth = w * 0.3
    let gap = (w - thinWidth - thickWidth) / 4
    let dotDiameter = thickWidth
    let dotRadius = dotDiameter / 2
    
    let thickX: CGFloat
    let thinX: CGFloat
    let dotsX: CGFloat
    
    if direction == .open {
      thickX = rect.minX
      thinX = thickX + thickWidth + gap
      dotsX = thinX + thinWidth + gap + dotRadius
    } else {
      thickX = rect.maxX - thickWidth
      thinX = thickX - thinWidth - gap
      dotsX = thinX - gap - dotRadius
    }
    
    var path = Path()
    
    path.addRect(CGRect(x: thickX, y: rect.minY, width: thickWidth, height: h))
    path.addRect(CGRect(x: thinX, y: rect.minY, width: thinWidth, height: h))
    
    path.addEllipse(in: CGRect(
      x: dotsX - dotRadius,
      y: rect.minY + h / 3 - dotRadius,
      width: dotDiameter,
      height: dotDiameter
    ))
    
    path.addEllipse(in: CGRect(
      x: dotsX - dotRadius,
      y: rect.minY + h * 2 / 3 - dotRadius,
      width: dotDiameter,
      height: dotDiameter
    ))

    return path
  }

  /// Framework-neutral `CGPath` for CALayer/CGContext renderers.
  public func cgPath(in rect: CGRect) -> CGPath { path(in: rect).cgPath }
}

#if DEBUG
#Preview {
  VStack {
    RepeatShape(direction: .open)
      .fill(Color.black)
      .frame(width: 30, height: 80)
      .border(Color.red)
    
    RepeatShape(direction: .closed)
      .fill(Color.black)
      .frame(width: 30, height: 80)
      .border(Color.red)
  }
  .frame(width: 250, height: 300)
  .background(Color.white)
  
}
#endif
