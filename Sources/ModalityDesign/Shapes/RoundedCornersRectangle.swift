import SwiftUI

public struct RectCorner: OptionSet, Sendable {
  public let rawValue: Int
  
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
  
  public static let topLeft     = RectCorner(rawValue: 1 << 0)
  public static let topRight    = RectCorner(rawValue: 1 << 1)
  public static let bottomLeft  = RectCorner(rawValue: 1 << 2)
  public static let bottomRight = RectCorner(rawValue: 1 << 3)
  
  
  public static let allCorners: RectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight]
  
  public static let left: RectCorner = [.topLeft, .bottomLeft]
  public static let right: RectCorner = [.topRight, .bottomRight]
  public static let top: RectCorner = [.topRight, .topLeft]
  public static let bottom: RectCorner = [.bottomRight, .bottomRight]
}

/// A shape that rounds only the specified corners of a rectangle.
public struct RoundedCornersRectangle: Shape {
  
  public var radius: CGFloat
  public var corners: RectCorner
  
  public init(
    radius: CGFloat = .infinity,
    corners: RectCorner = .allCorners
  ) {
    self.radius  = radius
    self.corners = corners
  }
  
  public func path(in rect: CGRect) -> Path {
    let r = min(radius, min(rect.width, rect.height) / 2)
    
    let tl = corners.contains(.topLeft)     ? r : 0
    let tr = corners.contains(.topRight)    ? r : 0
    let bl = corners.contains(.bottomLeft)  ? r : 0
    let br = corners.contains(.bottomRight) ? r : 0
    
    var path = Path()
    
    path.move(to: CGPoint(x: rect.minX + tl, y: rect.minY))
    
    // Top edge & top-right corner
    path.addLine(to: CGPoint(x: rect.maxX - tr, y: rect.minY))
    if tr > 0 {
      path.addArc(
        center: CGPoint(x: rect.maxX - tr, y: rect.minY + tr),
        radius: tr,
        startAngle: .degrees(-90),
        endAngle:   .degrees(0),
        clockwise: false
      )
    }
    
    // Right edge & bottom-right corner
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - br))
    if br > 0 {
      path.addArc(
        center: CGPoint(x: rect.maxX - br, y: rect.maxY - br),
        radius: br,
        startAngle: .degrees(0),
        endAngle:   .degrees(90),
        clockwise: false
      )
    }
    
    // Bottom edge & bottom-left corner
    path.addLine(to: CGPoint(x: rect.minX + bl, y: rect.maxY))
    if bl > 0 {
      path.addArc(
        center: CGPoint(x: rect.minX + bl, y: rect.maxY - bl),
        radius: bl,
        startAngle: .degrees(90),
        endAngle:   .degrees(180),
        clockwise: false
      )
    }
    
    // Left edge & top-left corner
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
    
    path.closeSubpath()
    return path
  }

  /// Framework-neutral `CGPath` for CALayer/CGContext renderers.
  public func cgPath(in rect: CGRect) -> CGPath { path(in: rect).cgPath }
}

#Preview {
  LazyVGrid(columns: [.init(.fixed(150)), .init(.fixed(150))]) {
    
    Group {
      RoundedCornersRectangle(radius: 16, corners: [.bottomRight])
        .fill(Color.brown)
      RoundedCornersRectangle(radius: 16, corners: [.bottomLeft])
        .fill(Color.yellow)
      RoundedCornersRectangle(radius: 16, corners: [.topRight])
        .fill(Color.red)
      RoundedCornersRectangle(radius: 16, corners: [.topLeft])
        .fill(Color.blue)
      
    }
    .frame(height: 150)
  }
    .padding(32)
    .frame(width: 400, height: 400)
}
