import SwiftUI

public struct VerticalAndCornerOutline: Shape {
  public var radius: CGFloat
  public var corners: RectCorner
  public var hasLeadingEdge: Bool
  public var hasTrailingEdge: Bool
  
  public init(radius: CGFloat, corners: RectCorner, hasLeadingEdge: Bool, hasTrailingEdge: Bool) {
    self.radius = radius
    self.corners = corners
    self.hasLeadingEdge = hasLeadingEdge
    self.hasTrailingEdge = hasTrailingEdge
  }
  
  public func path(in rect: CGRect) -> Path {
    let r = min(radius, min(rect.width, rect.height) / 2)
    
    let tl = corners.contains(.topLeft) ? r : 0
    let tr = corners.contains(.topRight) ? r : 0
    let bl = corners.contains(.bottomLeft) ? r : 0
    let br = corners.contains(.bottomRight) ? r : 0
    
    var path = Path()
    
    if hasLeadingEdge {
      path.move(to: CGPoint(x: rect.minX + bl, y: rect.maxY))
      
      if bl > 0 {
        path.addArc(
          center: CGPoint(x: rect.minX + bl, y: rect.maxY - bl),
          radius: bl,
          startAngle: .degrees(90),
          endAngle: .degrees(180),
          clockwise: false
        )
      }
      
      path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + tl))
      
      if tl > 0 {
        path.addArc(
          center: CGPoint(x: rect.minX + tl, y: rect.minY + tl),
          radius: tl,
          startAngle: .degrees(180),
          endAngle: .degrees(270),
          clockwise: false
        )
      }
    }
    
    if hasTrailingEdge {
      path.move(to: CGPoint(x: rect.maxX - tr, y: rect.minY))
      
      if tr > 0 {
        path.addArc(
          center: CGPoint(x: rect.maxX - tr, y: rect.minY + tr),
          radius: tr,
          startAngle: .degrees(-90),
          endAngle: .degrees(0),
          clockwise: false
        )
      }
      
      path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - br))
      
      if br > 0 {
        path.addArc(
          center: CGPoint(x: rect.maxX - br, y: rect.maxY - br),
          radius: br,
          startAngle: .degrees(0),
          endAngle: .degrees(90),
          clockwise: false
        )
      }
    }
    
    return path
  }
}
