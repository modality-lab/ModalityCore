import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public extension Selector {
  
  @MainActor
  func sendToApp() -> Bool {
    #if canImport(UIKit)
    guard let delegate = UIApplication.shared.delegate,
          delegate.responds(to: self) else { return false }
    UIApplication.shared.sendAction(self, to: delegate, from: nil, for: nil)
    return true
    #elseif canImport(AppKit)
    guard NSApp.delegate?.responds(to: self) == true else { return false }
    NSApp.sendAction(self, to: NSApp.delegate, from: nil)
    return true
    #endif
  }
}
