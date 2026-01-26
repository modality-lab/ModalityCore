import Foundation

public extension Task where Success == Never, Failure == Never {
  static func sleep(seconds: Double) async throws {
    let duration = UInt64(seconds * 1_000_000_000)
    try await Task.sleep(nanoseconds: duration)
  }
}

public extension Task where Failure == Error {
  static func delayed(
    seconds delayInterval: TimeInterval,
    priority: TaskPriority? = nil,
    @_implicitSelfCapture operation: @escaping @Sendable () async throws -> Success
  ) -> Task {
    Task(priority: priority) {
      let delay = UInt64(delayInterval * 1_000_000_000)
      try await Task<Never, Never>.sleep(nanoseconds: delay)
      return try await operation()
    }
  }
}
