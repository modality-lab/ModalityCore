import Foundation

public extension DispatchSource {
  static func schedule(
    at deadline: DispatchWallTime,
    queue: DispatchQueue = .main,
    operation: @escaping () -> Void
  ) -> any DispatchSourceTimer {
    let timer = DispatchSource.makeTimerSource(flags: .strict, queue: queue)
    timer.schedule(wallDeadline: deadline)
    timer.setEventHandler(qos: .userInteractive, flags: [], handler: operation)
    timer.resume()
    return timer
  }
}
