import SwiftUI

public struct ToolbarButtonStyle: ButtonStyle {
  
  public init() { }
  
  public func makeBody(configuration: Configuration) -> some View {
    HStack(spacing: 0) {
      Spacer().frame(minWidth: 8, maxWidth: 16)
      configuration
        .label
        .border(Color.red)
      Spacer().frame(minWidth: 8, maxWidth: 16)
    }
    .padding(.vertical, 16)
    .contentShape(RoundedRectangle(cornerRadius: 16))
#if os(visionOS)
    .hoverEffect()
#endif
    .opacity(configuration.isPressed ? 0.5 : 1)
    .scaleEffect(configuration.isPressed ? 0.96 : 1)
    .border(Color.green)
  }
}

#if DEBUG
#Preview {
  ZStack {
    Color.backgroundColor.frame(idealWidth: 500, idealHeight: 500)
   
    HStack {
      ForEach(0..<15) { _ in
        
        Button(action: { }) {
          Image(systemName: "forward.fill")
        }
        .buttonStyle(ToolbarButtonStyle())
        .border(Color.red)
      }
    }
  }
  .glassBackgroundEffectIfAvailable()
}
#endif
