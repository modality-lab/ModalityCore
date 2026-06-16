import SwiftUI

public struct PlayheadShape: Shape {
  
  private let headHeight: CGFloat
  
  public init(headHeight: CGFloat = 10) {
    self.headHeight = headHeight
  }
  
  public func path(in rect: CGRect) -> Path {
    var path = Path()
    
    let rectHeight: CGFloat = headHeight * 0.35
    let triangleHeight: CGFloat = headHeight - rectHeight
    let headWidth: CGFloat = rect.width
    let lineWidth: CGFloat = 2
    let rectWidth: CGFloat = headWidth
    
    // Center everything horizontally
    let centerX = rect.midX
    let rectTop = rect.minY
    let rectBottom = rect.minY + rectHeight
    let triangleTop = rectBottom
    let trianglBottom = triangleTop + triangleHeight
    let lineBottom = rect.maxY
    
    // Draw rectangular area at top
    let rectLeft = centerX - rectWidth / 2
    let rectRight = centerX + rectWidth / 2
    
//    path.addRect(CGRect(
//      x: rectLeft,
//      y: rectTop,
//      width: rectWidth,
//      height: rectHeight
//    ))
    
    path.addPath(
      RoundedCornersRectangle(radius: 4, corners: [.topLeft, .topRight])
        .path(in: CGRect(
          x: rectLeft,
          y: rectTop,
          width: rectWidth,
          height: rectHeight
        ))
    )
    
    // Draw triangular head pointing down
    path.move(to: CGPoint(x: centerX, y: trianglBottom))
    path.addLine(to: CGPoint(x: centerX - headWidth / 2, y: triangleTop))
    path.addLine(to: CGPoint(x: centerX + headWidth / 2, y: triangleTop))
    path.closeSubpath()
    
    // Draw vertical line from head to bottom
    let lineLeft = centerX - lineWidth / 2
    let lineRight = centerX + lineWidth / 2
    
    path.move(to: CGPoint(x: lineLeft, y: trianglBottom - 2))
    path.addLine(to: CGPoint(x: lineRight, y: trianglBottom - 2))
    path.addLine(to: CGPoint(x: lineRight, y: lineBottom))
    path.addLine(to: CGPoint(x: lineLeft, y: lineBottom))
    path.closeSubpath()

    return path
  }

  /// Framework-neutral `CGPath` for CALayer/CGContext renderers.
  public func cgPath(in rect: CGRect) -> CGPath { path(in: rect).cgPath }
}

#Preview {
  
  ZStack {
    PlayheadShape()
      .fill(Color.primaryPurple)
      .frame(width: 16, height: 50)
  }
  .frame(width: 30, height: 70)
}
