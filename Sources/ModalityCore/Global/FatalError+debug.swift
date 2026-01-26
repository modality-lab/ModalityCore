public func debugFatalError<DefaultValue>(
  defaultValue: @autoclosure () -> DefaultValue,
  message: String = #function,
  file: StaticString = #file,
  line: UInt = #line
) -> DefaultValue {
#if DEBUG
  Swift.fatalError(message, file: file, line: line)
#else
  return defaultValue()
#endif
}

public func debugAssert(
  _ condition: @autoclosure () -> Bool,
  _ message: @autoclosure () -> String = String(),
  file: StaticString = #file,
  line: UInt = #line
) {
#if DEBUG
  if !condition() {
    Swift.fatalError(message(), file: file, line: line)
  }
#endif
}

public func debugFatalError(
  message: String = #function,
  file: StaticString = #file,
  line: UInt = #line
) {
  _ = debugFatalError(defaultValue: Void.self)
}
