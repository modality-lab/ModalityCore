import SwiftUI

public extension AnyTransition {
  @MainActor static let scaleAndFade = AnyTransition.modifier(
    active: ScaleAndFade(isEnabled: true),
    identity: ScaleAndFade(isEnabled: false)
  )
}

struct ScaleAndFade: ViewModifier {
  var isEnabled: Bool

  func body(content: Content) -> some View {
    return content
      .scaleEffect(isEnabled ? 0.2 : 1)
      .opacity(isEnabled ? 0 : 1)
  }
}
