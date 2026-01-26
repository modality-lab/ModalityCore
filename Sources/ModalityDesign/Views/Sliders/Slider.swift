import SwiftUI

public struct RangeRestrictedSlider: View {

  @Binding private var value: Double
  private let range: ClosedRange<Double> = 0...1
  private let disabledUpTo: Double
  private let trackHeight: CGFloat
  private let thumbSize: CGFloat
  private let defaultValue: Double
  
  private let disabledWidth: Double
  
  private let tintColor: Color
  
  @State private var isDragging: Bool = false
  
  private var activeWidth: CGFloat {  
    return max(0, value - disabledWidth)
  }
  
  private var disabledSectionWidth: CGFloat {
    value
  }
  
  private var animation: Animation? {
    isDragging ? nil : .spring(duration: 0.5)
  }
  
  public init(
    value: Binding<Double>,
    disabledUpTo: Double = 0,
    defaultValue: Double = 0.5,
    trackHeight: CGFloat = 6,
    thumbSize: CGFloat = 18,
    tintColor: Color = .primaryPurple
  ) {
    self._value = value
    let disabledUpTo = max(range.lowerBound, disabledUpTo)
    self.disabledUpTo = disabledUpTo
    self.defaultValue = defaultValue
    self.trackHeight = trackHeight
    self.thumbSize = thumbSize
    self.disabledWidth = disabledUpTo.normalize(from: range.lowerBound, to: range.upperBound)
    self.tintColor = tintColor
  }
  
  public var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        Capsule()
          .fill(Color.gray.opacity(0.3))
          .frame(height: trackHeight)
        
        disabledTrack(trackWidth: geometry.size.width)
          .animation(animation, value: value)
        
        activeTrack(trackWidth: geometry.size.width)
        
        thumb
          .offset(x: value * geometry.size.width - thumbSize / 2)
          .animation(animation, value: value)
      }
      .frame(height: thumbSize)
      .contentShape(Rectangle())
      .highPriorityGesture(dragGesture(trackWidth: geometry.size.width))
      .simultaneousGesture(resetGesture)
    }
  }
  
  private func activeTrack(trackWidth: CGFloat) -> some View {
    Capsule()
      .fill(tintColor)
      .frame(width: activeWidth * trackWidth, height: trackHeight)
      .offset(x: disabledWidth * trackWidth)
      .animation(animation, value: value)
  }
  
  private func disabledTrack(trackWidth: CGFloat) -> some View {
    Capsule()
      .fill(Color.gray.opacity(0.4))
      .frame(width: disabledSectionWidth * trackWidth, height: trackHeight)
      .animation(animation, value: disabledSectionWidth)
      .overlay(
        // Diagonal lines pattern for disabled area
        Path { path in
          let spacing: CGFloat = 8
          var x: CGFloat = -trackHeight
          while x < disabledSectionWidth * trackWidth + trackHeight {
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x + trackHeight, y: trackHeight))
            x += spacing
          }
        }
        .stroke(Color.gray.opacity(0.6))
        .frame(width: disabledSectionWidth * trackWidth, height: trackHeight)
        .clipShape(Capsule())
      )
  }
  
  private var thumb: some View {
    Circle()
      .fill(Color.white)
      .frame(width: thumbSize, height: thumbSize)
      .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
      .overlay(
        Circle()
          .stroke(tintColor, lineWidth: 2)
      )
      .scaleEffect(isDragging ? 1.3 : 1.0)
      .animation(animation, value: isDragging)
  }
  
  private func dragGesture(trackWidth: CGFloat) -> some Gesture {
    DragGesture(minimumDistance: 0, coordinateSpace: .local)
      .onChanged { drag in
        guard trackWidth > 0 else { return }
        
        let normalizedPosition = max(0, min(1, Double(drag.location.x / trackWidth)))
        let newValue = normalizedPosition.lerp(from: range.lowerBound, to: range.upperBound)
        let clampedValue = max(disabledUpTo, min(range.upperBound, newValue))
        
        value = clampedValue
        
        if !isDragging {
          isDragging = true
        }
      }
      .onEnded { _ in
        isDragging = false
        
        if value < disabledUpTo {
          value = disabledUpTo
        }
      }
  }
  
  private var resetGesture: some Gesture {
    TapGesture(count: 2)
      .onEnded { 
        value = max(disabledUpTo, defaultValue)
      }
  }
}

// MARK: - Preview

#Preview {
  VStack(spacing: 40) {
    VStack {
      Text("Normal Slider")
      RangeRestrictedSlider(
        value: .constant(0.3),
        disabledUpTo: 0.0
      )
    }
    
    VStack {
      var value = 0.5
      Text("Draggable Slider")
      
      RangeRestrictedSlider(
        value: .init(get: { value }, set: { value = $0 }),
        disabledUpTo: 0.0
      )
    }
    
    VStack {
      Text("Slider with 25% disabled")
      RangeRestrictedSlider(
        value: .constant(0.6),
        disabledUpTo: 0.25
      )
    }
    
    VStack {
      Text("Slider with 50% disabled")
      RangeRestrictedSlider(
        value: .constant(1),
        disabledUpTo: 0.5
      )
    }
    
    VStack {
      Text("Slider with value in disabled range")
      RangeRestrictedSlider(
        value: .constant(0.2),
        disabledUpTo: 0.4
      )
    }
  }
  .padding()
}

