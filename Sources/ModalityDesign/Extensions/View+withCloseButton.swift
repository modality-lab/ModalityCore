import SwiftUI

public extension View {
  var withCloseButton: some View {
    modifier(WithCloseButtonSheetModifier())
  }
}

fileprivate struct WithCloseButtonSheetModifier: ViewModifier {
  
  func body(content: Content) -> some View {
    VStack(spacing: 0) {
      HStack {
        Spacer()
        CloseButton()
          .fixedSize()
          .padding(.top, 16)
          .padding(.trailing, 24)
      }
      
      content
    }
  }
}
