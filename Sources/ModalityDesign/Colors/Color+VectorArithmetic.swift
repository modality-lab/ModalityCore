import SwiftUI
import ModalityCore

extension Color: @retroactive VectorArithmetic {
  public static func - (lhs: Color, rhs: Color) -> Color {
    let lhsComponents = lhs.components
    let rhsComponents = rhs.components
    
    let red = max(lhsComponents.red - rhsComponents.red, 0.0)
    let green = max(lhsComponents.green - rhsComponents.green, 0.0)
    let blue = max(lhsComponents.blue - rhsComponents.blue, 0.0)
    let alpha = max(lhsComponents.alpha - rhsComponents.alpha, 0.0)
    
    return Color(red: Double(red), green: Double(green), blue: Double(blue), opacity: Double(alpha))
  }
  
  public static func + (lhs: Color, rhs: Color) -> Color {
    let lhsComponents = lhs.components
    let rhsComponents = rhs.components
    
    let red = min(lhsComponents.red + rhsComponents.red, 1.0)
    let green = min(lhsComponents.green + rhsComponents.green, 1.0)
    let blue = min(lhsComponents.blue + rhsComponents.blue, 1.0)
    let alpha = min(lhsComponents.alpha + rhsComponents.alpha, 1.0)
    
    return Color(red: Double(red), green: Double(green), blue: Double(blue), opacity: Double(alpha))
  }
  
  public mutating func scale(by rhs: Double) {
    let components = self.components
    
    let red = Double(components.red) * rhs
    let green = Double(components.green) * rhs
    let blue = Double(components.blue) * rhs
    let alpha = Double(components.alpha) * rhs
    
    self = Color(red: red, green: green, blue: blue, opacity: alpha)
  }
  
  public var magnitudeSquared: Double {
    let components = self.components
    
    return Double(components.red * components.red + components.green * components.green + components.blue * components.blue + components.alpha * components.alpha)
  }
  
  public static var zero: Color {
    .black
  }
  
  public func mixed(with color: Color, by amount: Double) -> Color {
    let lhsComponents = self.components
    let rhsComponents = color.components
    
    let red = amount.lerp(from: Double(lhsComponents.red), to: Double(rhsComponents.red))
    let green = amount.lerp(from: Double(lhsComponents.green), to: Double(rhsComponents.green))
    let blue = amount.lerp(from: Double(lhsComponents.blue), to: Double(rhsComponents.blue))
    let alpha = amount.lerp(from: Double(lhsComponents.alpha), to: Double(rhsComponents.alpha))
    
    return Color(red: red, green: green, blue: blue, opacity: alpha)
  }
}
