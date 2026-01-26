import SwiftUI
import ModalityCore

public struct WedgeShape: Shape {

  let geometry: WedgeGeometry
  
  public init(geometry: WedgeGeometry) {
    self.geometry = geometry
  }

  public func path(in rect: CGRect) -> Path {
    var path = Path()

    path.addArc(
      center: geometry.center,
      radius: geometry.innerRadius,
      startAngle: geometry.start,
      endAngle: geometry.end,
      clockwise: false
    )
    path.addLine(to: geometry[.bottomTrailing])
    path.addArc(
      center: geometry.center,
      radius: geometry.outerRadius,
      startAngle: geometry.end,
      endAngle: geometry.start,
      clockwise: true
    )
    path.closeSubpath()

    return path
  }
}

public struct WedgeGeometry: Sendable {

  public let start: Angle
  public let end: Angle
  public let innerRadius: CGFloat
  public let outerRadius: CGFloat
  public let centerRadius: CGFloat

  public let size: CGSize
  public let center: CGPoint
  public let yShift: CGFloat

  public init(
    start: Angle,
    end: Angle,
    innerRadiusNorm: CGFloat,
    outerRadiusNorm: CGFloat,
    size: CGSize,
    shiftFactor: CGFloat,
    scaleFactor: CGFloat,
    aspectRatio: CGFloat
  ) {
    self.start = start
    self.end = end

    let minDemension = min(size.height, size.width * aspectRatio) * scaleFactor
    
    self.size = size
    self.yShift = minDemension * shiftFactor
    self.center = CGPoint(
      x: size.width / 2,
      y: size.height / 2 + yShift
    )
    
    self.innerRadius = minDemension * (innerRadiusNorm)
    self.outerRadius = minDemension * (outerRadiusNorm)
    self.centerRadius = (innerRadius + outerRadius) / 2
  }

  public subscript(unitPoint: UnitPoint) -> CGPoint {
    let radius = unitPoint.y.lerp(from: innerRadius, to: outerRadius)
    let angle = Double(unitPoint.x).lerp(from: start.radians, to: end.radians)

    return CGPoint(
      x: center.x + CGFloat(cos(angle)) * radius,
      y: center.y + CGFloat(sin(angle)) * radius
    )
  }
}
