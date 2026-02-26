import SwiftUI

public struct SettingsGearButton<Label: View, SettingsView: View>: View {

  @ViewBuilder let label: () -> Label
  @ViewBuilder let settingsView: () -> SettingsView
  @State var isSettingsPresented: Bool = false
  @Environment(\.dismiss) var dismiss
  
  public init(
    @ViewBuilder label: @escaping () -> Label = {
      Image(systemName: "gear")
        .resizable()
        .frame(width: 24, height: 24)
        .padding(16)
    },
    @ViewBuilder settingsView: @escaping () -> SettingsView
  ) {
    self.label = label
    self.settingsView = settingsView
  }
  
  public var body: some View {
    Group {
#if os(macOS)
      if #available(macOS 14.0, *) {
        SettingsLink(label: label)
      } else {
        Button(
          action: {
            if Selector("showSettingsWindow:").sendToApp() { return }
            if Selector("showPreferencesWindow:").sendToApp() { return }
          },
          label: label
        )
      }
#else
      Button(
        action: { isSettingsPresented = true },
        label: label
      )
      .sheet(isPresented: $isSettingsPresented) {
        settingsView()
      }
#endif
    }
    .buttonStyle(.plain)
  }
}
