import SwiftUI

#if os(macOS)
import AppKit

public struct WindowAccessor: NSViewRepresentable {
  
  let onWindow: (NSWindow?) -> Void
  
  public init(onWindow: @escaping (NSWindow?) -> Void) {
    self.onWindow = onWindow
  }
  
  public func makeNSView(context: Context) -> NSView {
    let view = NSView()
    DispatchQueue.main.async {
      onWindow(view.window)
    }
    return view
  }
  
  public func updateNSView(_ nsView: NSView, context: Context) {
    DispatchQueue.main.async {
      onWindow(nsView.window)
    }
  }
}
#endif
