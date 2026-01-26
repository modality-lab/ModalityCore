import SwiftUI

public extension View {

  func alert(presenting error: Binding<Error?>) -> some View {
    modifier(AlertModifier(error: error))
  }
}

private struct AlertModifier: ViewModifier {

  @Binding var error: Error?

  init(error: Binding<Error?>) {
    self._error = error
  }

  func body(content: Content) -> some View {
    content
      .alert("Whoops",
        isPresented: .init(get: {
          error != nil
        }, set: { _ in
          error = nil
        })
      ) {
        Button {
          error = nil
        } label: {
          Text("Got it")
        }
      } message: {
        let errorText = error != nil ? "\(error!)" : "An error occured"
        Text(errorText)
      }
  }
}
