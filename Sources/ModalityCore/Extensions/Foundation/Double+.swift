import Foundation

extension Double {
  
  public var int: Int {
    Int(self)
  }
  
  public var f2: String {
    formatted(2)
  }
  
  public var f6: String {
    formatted(6)
  }
  
  public func formatted(_ decimalPlaces: Int = 6) -> String {
    String(format: "%.\(decimalPlaces)f", self)
  }
  
  public var signValue: Double {
    self == 0 ? 0 : (self > 0 ? 1 : -1)
  }
}
