import os
import Foundation

public extension Logger {
  init(category: String) {
    self.init(subsystem: Bundle.main.bundleIdentifier ?? "unknown subsystem", category: category)
  }
  
  init(bundle: Bundle, fileID: StaticString = #fileID) {
    let file = "\(fileID)".components(separatedBy: "/").first ?? "\(fileID)"
    self.init(subsystem: bundle.bundleIdentifier ?? "unknown", category: file)
  }
}

public extension Logger {
  static let `default` = Logger(subsystem: "", category: "default")
}

public extension Logger {
  func debugLog(_ level: OSLogType = .info, message: () -> String) {
#if DEBUG
    let msg = message()
    self.log(level: level, "\(msg)")
#endif
  }
}
