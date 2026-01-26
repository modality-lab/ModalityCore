import SwiftUI
import ModalityCore

public struct WedgeView<Content: Equatable & Hashable>: View {

  var wedge: Ring<Content>.Wedge
  let ring: Ring<Content>
  
  public init(
    wedge: Ring<Content>.Wedge,
    ring: Ring<Content>
  ) {
    self.ring = ring
    self.wedge = wedge
  }

  public var body: some View {
    GeometryReader { geometryProxy in
      let geometry = WedgeGeometry(
        start: wedge.start,
        end: wedge.end,
        innerRadiusNorm: ring.innerRadius,
        outerRadiusNorm: ring.outerRadius,
        size: geometryProxy.size,
        shiftFactor: ring.yShift,
        scaleFactor: ring.scale,
        aspectRatio: ring.aspectRatio
      )
      
      wedgeShape(from: geometry)
        .fill(wedge.edgeColor)
        .overlay {
          Group {
            let angle = wedge.center + .degrees(90)
            switch wedge.content.type {
            case .label:
              iOS16AnimationFixedLabel(text: wedge.content.text, rotation: angle, radius: geometry.centerRadius)
                .id(wedge.id)
            case .circularLabel:
              CircularLabel(text: wedge.content.text, radius: geometry.centerRadius, startAngle: angle)
            }
          }
          .offset(y: geometry.yShift)
          .font(wedge.content.font.monospaced())
          .foregroundStyle(.primary)
        }
    }
  }

  private func wedgeShape(from geometry: WedgeGeometry) -> some Shape {
    let shape = WedgeShape(geometry: geometry)

    if #available(macOS 14.0, iOS 17.0, visionOS 1.0, *) {
      return shape
        .subtracting(shape.stroke(style: StrokeStyle(lineWidth: 4, lineCap: .butt, lineJoin: .round)))
    } else {
      // TODO: Implement fallback
      return shape
    }
  }
}

extension WedgeView: @preconcurrency Animatable {
  public var animatableData: Ring<Content>.Wedge.AnimatableData {
    get { wedge.animatableData }
    set { wedge.animatableData = newValue }
  }
}

fileprivate struct iOS16AnimationFixedLabel: View {
  
  let text: String
  let rotation: Angle
  let radius: Double
  
  var body: some View {
    VStack {
      Text(text)
        .rotationEffect(-rotation)
      
      Spacer()
        .frame(height: radius * 2)
    }
    .rotationEffect(rotation)
  }
}
