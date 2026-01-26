import Foundation

public extension Date {
  private static let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss:SSS"
    return formatter
  }()
  
  var timeFormatted: String {
    Self.formatter.string(from: self)
  }
  
  var logging: String {
    "\(timeFormatted), ts: \(timeIntervalSince1970)"
  }
}
