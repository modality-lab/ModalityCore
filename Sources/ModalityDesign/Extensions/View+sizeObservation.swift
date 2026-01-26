import SwiftUI
import os

fileprivate struct BindSizeModifier: ViewModifier {

  @Binding var size: CGSize?
  
  func body(content: Content) -> some View {
    content
      .background(
        GeometryReader { proxy in
          DispatchQueue.main.async {
            size = proxy.size
          }
          return Color.clear
        }
      )
  }
}

fileprivate struct ObserveSizeModifier: ViewModifier {

  var callback: (CGSize) -> Void
  
  func body(content: Content) -> some View {
    content
      .background(
        GeometryReader { proxy in
          DispatchQueue.main.async {
            callback(proxy.size)
          }
          return Color.clear
        }
      )
  }
}

public extension View {
  func bindSize(to size: Binding<CGSize?>) -> some View {
    modifier(BindSizeModifier(size: size))
  }
  
  func observeSize(callback: @escaping (CGSize) -> Void) -> some View{
    modifier(ObserveSizeModifier(callback: callback))
  }
  
  func printSize(label: String? = nil) -> some View {
    let label = label ?? Mirror(reflecting: self).description
    return observeSize { size in
      Logger.default.log("Size: \(label): \(size.debugDescription)")
    }
  }
}
