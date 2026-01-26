import Foundation

public extension String {
  
  private static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
  
  var isValidEmail: Bool {
    isMatch(regex: Self.emailRegex)
  }
}

public extension String {
  
  func isMatch(regex regexPattern: String) -> Bool {
    range(of: regexPattern, options: .regularExpression) != nil
  }
  
  var lastPathComponent: String {
    (self as NSString).lastPathComponent
  }
}

public extension String.StringInterpolation {

  mutating func appendInterpolation<T: CustomStringConvertible>(_ value: T?) {
    appendInterpolation(value ?? "nil" as CustomStringConvertible)
  }
}

public extension String.StringInterpolation {
  mutating func appendInterpolation(json JSONData: Data) {
    guard
      let JSONObject = try? JSONSerialization.jsonObject(with: JSONData, options: []),
      let jsonData = try? JSONSerialization.data(withJSONObject: JSONObject, options: .prettyPrinted) else {
      appendInterpolation(String(data: JSONData, encoding: .utf8))
      return
    }
    appendInterpolation("\(String(decoding: jsonData, as: UTF8.self))")
  }
}
