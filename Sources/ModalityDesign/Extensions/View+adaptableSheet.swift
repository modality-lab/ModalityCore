import SwiftUI

public extension View {
  var adaptableSheet: some View {
    modifier(AdaptableSheetModifier())
  }
}

fileprivate struct AdaptableSheetModifier: ViewModifier {
  @State private var size: CGSize?
  
  func body(content: Content) -> some View {
    content
      .bindSize(to: $size)
      .presentationDetents(height: size?.height)
  }
}

fileprivate extension View {
  
  @ViewBuilder
  func presentationDetents(height: CGFloat?) -> some View {
    if #available(iOS 16.4, macOS 13.3, *) {
      presentationDetents([.detents(for: height)])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(32)
    } else if #available(iOS 16.0, macOS 13.0, *) {
      presentationDetents([.detents(for: height)])
        .presentationDragIndicator(.visible)
    }
  }
}

@available(iOS 16.0, macOS 13.0, *)
fileprivate extension PresentationDetent {
  static func detents(for height: CGFloat?) -> Self {
    height != nil ? .height(height!) : .fraction(0.3)
  }
}
