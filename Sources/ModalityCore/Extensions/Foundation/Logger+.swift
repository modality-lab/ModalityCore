import os
import Foundation

public extension Logger {
  init(category: String) {
    self.init(subsystem: Bundle.main.bundleIdentifier ?? "unknown subsystem", category: category)
  }
}

public extension Logger {
  static let `default` = Logger(category: "default")
}

public extension Logger {
  func debugLog(_ level: OSLogType = .info, message: () -> String) {
#if DEBUG
    let msg = message()
    self.log(level: level, "\(msg)")
#endif
  }
}
