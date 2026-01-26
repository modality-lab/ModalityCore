import SwiftUI

public extension View {

  @ViewBuilder
  func monospacedIfAvailable() -> some View {
    if #available(macOS 13.0, iOS 16.0, *) {
      self.monospaced()
    } else {
      self
    }
  }

  @ViewBuilder
  func boldIfAvailable() -> some View {
    if #available(macOS 13.0, iOS 16.0, *) {
      self.bold()
    } else {
      self
    }
  }

  @ViewBuilder
  func glassBackgroundEffectIfAvailable() -> some View {
    self
      #if os(visionOS)
      .glassBackgroundEffect()
      #endif
  }
  
  @ViewBuilder
  func popoverPresentationIfAvailable() -> some View {
    if #available(macOS 13.3, iOS 16.4, *) {
      self.presentationCompactAdaptation(.popover)
        .presentationBackground { Color.backgroundColor }
    } else {
      self
    }
  }
  
  @ViewBuilder
  func inspectorIfAvailable<V: View>(
    isPresented: Binding<Bool>,
    @ViewBuilder content: () -> V
  ) -> some View {
    #if os(visionOS)
    self
    #else
    if #available(macOS 14, iOS 17, *) {
      self.inspector(isPresented: isPresented, content: content)
    } else {
      self
    }
    #endif
  }
}
