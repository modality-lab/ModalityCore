#if os(iOS)
import UIKit
import SwiftUI

final class ContentViewController<V>: UIHostingController<V>, UIPopoverPresentationControllerDelegate where V:View {
  var isPresented: Binding<Bool>
  
  init(rootView: V, isPresented: Binding<Bool>) {
    self.isPresented = isPresented
    super.init(rootView: rootView)
  }
  
  required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    self.isPresented.wrappedValue = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let size = sizeThatFits(in: UIView.layoutFittingExpandedSize)
    preferredContentSize = size
  }
  
  func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
    return .none
  }
}


struct AlwaysPopoverModifier<PopoverContent>: ViewModifier where PopoverContent: View {
  
  @MainActor
  private struct Store {
    var anchorView = UIView()
  }
  
  let isPresented: Binding<Bool>
  let contentBlock: () -> PopoverContent
  @State private var store = Store()
  
  func body(content: Content) -> some View {
    if isPresented.wrappedValue {
      presentPopover()
    }
    
    return content
      .background(InternalAnchorView(uiView: store.anchorView))
  }
  
  private func presentPopover() {
    let contentController = ContentViewController(rootView: contentBlock(), isPresented: isPresented)
    contentController.modalPresentationStyle = .popover
    
    let view = store.anchorView
    guard let popover = contentController.popoverPresentationController else { return }
    popover.sourceView = view
    popover.sourceRect = view.bounds
    popover.delegate = contentController
    
    guard let sourceVC = view.closestViewController else { return }
    
    if let presentedVC = sourceVC.presentedViewController {
      presentedVC.dismiss(animated: true) {
        sourceVC.present(contentController, animated: true)
      }
    } else {
      sourceVC.present(contentController, animated: true)
    }
  }
}

private struct InternalAnchorView: UIViewRepresentable {
  typealias UIViewType = UIView
  let uiView: UIView
  
  func makeUIView(context: Self.Context) -> Self.UIViewType {
    uiView
  }
  
  func updateUIView(_ uiView: Self.UIViewType, context: Self.Context) { }
}

extension View {
  public func alwaysPopover<Content>(
    isPresented: Binding<Bool>,
    @ViewBuilder content: @escaping () -> Content
  ) -> some View where Content : View {
    self.modifier(AlwaysPopoverModifier(isPresented: isPresented, contentBlock: content))
  }
}

extension UIView {
  var closestViewController: UIViewController? {
    var nextResponder: UIResponder? = self
    while let responder = nextResponder {
      if let viewController = responder as? UIViewController {
        return viewController
      }
      nextResponder = responder.next
    }
    return nil
  }
}
#endif
