import Foundation

public extension TimeInterval {
  
  static func minutes(_ minutes: Double) -> TimeInterval {
    minutes * 60
  }
  
  static func hours(_ hours: Double) -> TimeInterval {
    hours * 3600
  }
}
