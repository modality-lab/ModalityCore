public extension Dictionary {
  mutating func addOptional(_ key: Key, value: Value?) {
    if let wrapped = value {
      self[key] = wrapped
    }
  }
}
