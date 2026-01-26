import SwiftUI

public extension View {
  
  func errorBorder(isError: Binding<Bool>, text: Binding<String>, cornerRadius: CGFloat = 8) -> some View {
    modifier(ErrorFlagBorderModifier(isError: isError, text: text, cornerRadius: cornerRadius))
  }
  
  @ViewBuilder
  func errorPopup(
    isPresented: Bool,
    title: String?,
    description: String?,
    onTryAgain: @escaping () -> Void
  ) -> some View {
    self
      .opacity(isPresented ? 0.8 : 1)
      .saturation(isPresented ? 0.5 : 1)
      .overlay {
        if isPresented {
          ErrorPopupView(
            title: title,
            description: description,
            onTryAgain: onTryAgain
          )
          .shadow(color: .black, radius: 24)
        }
      }
  }
}

public struct ErrorFlagBorderModifier: ViewModifier {
  @Binding private var isError: Bool
  @Binding private var text: String
  private let cornerRadius: CGFloat
  
  public init(isError: Binding<Bool>, text: Binding<String>, cornerRadius: CGFloat) {
    self._isError = isError
    self._text = text
    self.cornerRadius = cornerRadius
  }
  
  public func body(content: Content) -> some View {
    content
      .overlay(
        RoundedRectangle(cornerRadius: cornerRadius)
          .stroke(isError ? VioletPalette.errorViolet : VioletPalette.border, lineWidth: 1)
      )
      .onChange(of: text) { _ in
        if isError { isError = false }
      }
  }
}
