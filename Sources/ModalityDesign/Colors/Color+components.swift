import SwiftUI
import os

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension Color {
  public var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
#if canImport(UIKit)
    typealias NativeColor = UIColor
#elseif canImport(AppKit)
    typealias NativeColor = NSColor
#endif
    
    var r: CGFloat = 0
    var g: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0
    
    NativeColor(self)
#if os(macOS)
      .usingColorSpace(.sRGB)?
#endif
      .getRed(&r, green: &g, blue: &b, alpha: &a)
    
    return (r, g, b, a)
  }
  
  var hex: String {
    String(
      format: "#%02x%02x%02x%02x",
      Int(components.red * 255),
      Int(components.green * 255),
      Int(components.blue * 255),
      Int(components.alpha * 255)
    )
  }
}
