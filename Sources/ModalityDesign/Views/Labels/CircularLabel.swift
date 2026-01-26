import SwiftUI

public struct CircularLabel: View {
  
  let text: String
  let radius: Double
  let startAngle: Angle
  let isUpsideDown: Bool
  
  public init(text: String, radius: Double, startAngle: Angle) {
    self.radius = radius
    self.startAngle = startAngle
    
    let degrees = {
      let degrees = Int(startAngle.degrees.rounded()) % 360
      return if degrees < -180 { degrees + 360 }
        else if degrees >= 180 { degrees - 360 }
        else { degrees }
    }()
    
    self.isUpsideDown = abs(degrees) > 90
    self.text = isUpsideDown ? String(text.reversed()) : text
  }

  @State var textWidths: [Int: Double] = [:]

  public var body: some View {
    ZStack {
      ForEach(Array(text.enumerated()), id: \.offset) { index, letter in
        VStack {
          Text(String(letter))
            .rotationEffect(isUpsideDown ? .degrees(180) : .zero)
            .background {
              GeometryReader { geometry in
                Color.clear
                  .preference(key: WidthPreferenceKey.self, value: geometry.size.width)
              }
            }
            .onPreferenceChange(WidthPreferenceKey.self, perform: { width in
              DispatchQueue.main.async {
                textWidths[index] = width
              }
            })

          Spacer()
            .frame(height: radius * 2)
        }
        .rotationEffect(startAngle + angle(at: index))
      }
    }
  }

  private func angle(at index: Int) -> Angle {
    guard let letterWidth = textWidths[index] else { return .radians(0) }

    let widthBeforeLabel = textWidths
      .filter { $0.key < index }
      .map { $0.value }
      .reduce(0, +)

    let allTextWidth = textWidths 
      .map { $0.value }
      .reduce(0, +)

    return .radians((widthBeforeLabel - allTextWidth / 2 + letterWidth / 2) / (radius))
  }
}

@MainActor
struct WidthPreferenceKey: @preconcurrency PreferenceKey {
  static var defaultValue: Double = 0
  static func reduce(value: inout Double, nextValue: () -> Double) {
    value = nextValue()
  }
}

#Preview {
  CircularLabel(
    text: "Latitude 35.08587 E • Longitude 21.43673 W • Elevation 64M • Incline 12 •".uppercased(),
    radius: 200,
    startAngle: .zero
  )
  .font(.system(size: 13, design: .monospaced))
}
