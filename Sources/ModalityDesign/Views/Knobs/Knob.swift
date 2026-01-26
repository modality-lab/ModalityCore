import SwiftUI
import Combine

public struct Knob: View {
  
  @Binding public var value: Double
  public let range: ClosedRange<Double>
  public let defaultValue: Double
  public let label: String
  
  public let diameter: CGFloat
  public let trackWidth: CGFloat
  public let sensitivity: Double
  public let fineMultiplier: Double
  public let strokeColor: Color
  
  @GestureState private var drag = CGSize.zero
  @State private var anchor: Double = 0
  
  @State private var isDragging: Bool = false
  
  public init(
    value: Binding<Double>,
    range: ClosedRange<Double> = 0...1,
    defaultValue: Double? = nil,
    label: String = "",
    diameter: CGFloat = 32,
    trackWidth: CGFloat = 3,
    sensitivity: Double = 0.006,
    fineMultiplier: Double = 0.2,
    strokeColor: Color = .primary
  ) {
    self._value = value
    self.range = range
    self.defaultValue = defaultValue ?? range.upperBound
    self.label = label
    self.diameter = diameter
    self.trackWidth = trackWidth
    self.sensitivity = sensitivity
    self.fineMultiplier = fineMultiplier
    self.strokeColor = strokeColor
  }
  
  private var animation: Animation? {
    isDragging ? nil : .spring(duration: 0.5)
  }
  
  public var body: some View {
    ZStack {
      Circle()
        .trim(from: 0.125, to: 0.875)
        .stroke(.black, style: StrokeStyle(lineWidth: trackWidth, lineCap: .round))
        .rotationEffect(.degrees(90))
      
      Circle()
        .trim(from: 0.125, to: 0.125 + progress * 0.75)
        .stroke(strokeColor, style: StrokeStyle(lineWidth: trackWidth, lineCap: .round))
        .rotationEffect(.degrees(90))
      
      Indicator(trackWidth: trackWidth)
        .stroke(strokeColor, lineWidth: trackWidth * 0.7)
        .rotationEffect(.degrees(225 + 270 * progress))
    }
    .animation(animation, value: progress)
    .frame(width: diameter, height: diameter)
    .contentShape(Rectangle())
    .gesture(dragGesture)
    .simultaneousGesture(resetGesture)
    .onAppear { anchor = value }
  }
  
  private var dragGesture: some Gesture {
    DragGesture(minimumDistance: 0)
      .updating($drag) { current, state, _ in state = current.translation }
      .onChanged { event in updateValue(with: event) }
      .onEnded { _ in
        isDragging = false
        anchor = value
      }
  }
  
  private var resetGesture: some Gesture {
    TapGesture(count: 2)
      .onEnded { value = defaultValue }
  }
  
  private func updateValue(with event: DragGesture.Value) {
    let px = -event.translation.height + event.translation.width * 0.4
    
#if os(macOS)
    let fine = NSEvent.modifierFlags.contains(.shift) ? fineMultiplier : 1
#else
    let fine = 1.0
#endif
    
    let delta = px * sensitivity * fine
    value = (anchor + delta).clamped(to: range)
    
    if !isDragging {
      isDragging = true
    }
  }
  
  private var progress: Double {
    (value - range.lowerBound) / (range.upperBound - range.lowerBound)
  }
}

private struct Indicator: Shape {
  let trackWidth: CGFloat
  func path(in rect: CGRect) -> Path {
    let radius = rect.width * 0.5
    let indicatorRadius = radius - trackWidth / 3
    let center = CGPoint(x: rect.midX, y: rect.midY)
    
    var path = Path()
    path.move(to: center)
    path.addLine(to: CGPoint(x: center.x, y: center.y - indicatorRadius))
    return path
  }
}

private extension Comparable {
  func clamped(to limits: ClosedRange<Self>) -> Self {
    min(max(self, limits.lowerBound), limits.upperBound)
  }
}
