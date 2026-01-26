import Foundation

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension String {
  public func requiredSize(for font: UXFont) -> CGSize {
    (self as NSString).size(withAttributes: [.font: font])
  }
}

#if os(macOS)
public typealias UXFont = NSFont
#else
public typealias UXFont = UIFont
#endif
