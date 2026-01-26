import SwiftUI

public struct StateToggleButton: View {
  let help: String
  let systemImage: String
  let systemImageFilled: String
  let accentColor: Color
  @Binding var isOn: Bool
  
  public init(
    help: String,
    systemImage: String,
    systemImageFilled: String,
    accentColor: Color,
    isOn: Binding<Bool>
  ) {
    self.help = help
    self.systemImage = systemImage
    self.systemImageFilled = systemImageFilled
    self.accentColor = accentColor
    self._isOn = isOn
  }
  
  public var body: some View {
    Button(action: { isOn.toggle() }) {
      Image(systemName: isOn ? systemImageFilled : systemImage)
        .scaleEffect(x: -1, y: 1, anchor: .center)
        .font(.system(size: 16, weight: .semibold))
        .foregroundStyle(isOn ? accentColor : .secondary)
        .frame(width: 36, height: 24)
        .contentShape(Rectangle())
        .overlay(
          RoundedRectangle(cornerRadius: 12)
            .stroke(isOn ? Color.primaryPurple.opacity(0.7) : Color.gray.opacity(0.3))
        )
        .shadow(
          color: isOn ? Color.primaryPurple.opacity(0.3) : Color.clear,
          radius: 6
        )
        .animation(.button, value: isOn)
    }
    .buttonStyle(.plain)
    .help(help)
  }
}
