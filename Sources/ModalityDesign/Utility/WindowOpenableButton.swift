import SwiftUI
import os

public struct WindowID: Sendable, RawRepresentable, Hashable {
  public let rawValue: String
  
  public init(rawValue: String) {
    self.rawValue = rawValue
  }
  
  // MARK: - App Windows
  // TODO: Move to Domain
  public static let fretboard = WindowID(rawValue: "Fretboard")
  public static let pitchTimeline = WindowID(rawValue: "PitchTimeline")
  public static let spiralOfFifthsInfo = WindowID(rawValue: "SoFInfo")
}

public struct WindowOpenableButton<Label: View, WindowContent: View>: View {
  
  @ViewBuilder let label: () -> Label
  @ViewBuilder var windowContent: () -> WindowContent
  let windowTitle: String?
  let windowId: WindowID?
  @State var isWindowOpened = false
  
  #if os(macOS)
  @State var window: NSWindow?
  @State private var windowClosingDelegate: WindowClosingDelegate?
  #elseif os(visionOS)
  @Environment(\.openWindow) private var openWindow
  @Environment(\.dismissWindow) private var dismissWindow
  #endif

  public init(
    windowTitle: String? = nil,
    windowId: WindowID? = nil,
    @ViewBuilder label: @escaping () -> Label,
    @ViewBuilder windowContent: @escaping () -> WindowContent
  ) {
    self.windowTitle = windowTitle
    self.windowId = windowId
    self.label = label
    self.windowContent = windowContent
  }
  
  @ViewBuilder
  public var body: some View {
    Button(
      action: {
        #if os(macOS)
        if isWindowOpened {
          window?.close()
        } else {
          windowClosingDelegate = WindowClosingDelegate(isWindowOpened: $isWindowOpened)
          window = windowContent().openInWindow(title: windowTitle, sender: self, windowClosingDelegate: windowClosingDelegate)
        }
        isWindowOpened.toggle()
        #elseif os(visionOS)
        if let windowId {
          if isWindowOpened {
            dismissWindow(id: windowId.rawValue)
          } else {
            openWindow(id: windowId.rawValue)
          }
          isWindowOpened.toggle()
        }
        #else
        Logger.default.error("WindowOpenableButton is not implemented for this OS yet.")
        #endif
      },
      label: label
    )
  }
}

#if os(macOS)
@available(macOS 10.15, *)
fileprivate extension View {
  
  @discardableResult
  func openInWindow(title: String?, sender: Any?, windowClosingDelegate: WindowClosingDelegate?) -> NSWindow {
    let controller = NSHostingController(rootView: self)
    let window = NSWindow(contentViewController: controller)
    window.contentViewController = controller
//    if let title {
//      window.title = nil
//    }
    window.makeKeyAndOrderFront(sender)
    window.delegate = windowClosingDelegate
    window.styleMask = [.miniaturizable, .closable, .titled, .fullSizeContentView, .resizable]
    window.titlebarAppearsTransparent = true
    window.titleVisibility = .hidden
    return window
  }
}

@available(macOS 10.15, *)
fileprivate final class WindowClosingDelegate: NSObject, NSWindowDelegate {
  
  @Binding var isWindowOpened: Bool
  
  init(isWindowOpened: Binding<Bool>) {
    self._isWindowOpened = isWindowOpened
  }
  
  func windowWillClose(_ notification: Notification) {
    isWindowOpened = false
  }
}
#endif
