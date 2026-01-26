import Foundation

public struct StringError: LocalizedError {
  public let errorDescription: String

  init(_ error: String) {
    self.errorDescription = error
  }
}

public extension String {
  var error: StringError {
    StringError(self)
  }
}
