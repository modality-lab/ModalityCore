import Foundation

public extension TimeInterval {
  
  static func minutes(_ minutes: TimeInterval) -> TimeInterval {
    minutes * 60
  }
  
  static func hours(_ hours: TimeInterval) -> TimeInterval {
    hours * 3600
  }
}
