public extension KeyedEncodingContainer {
  mutating func encodeIfNotEmpty<T: Encodable>(_ value: [T], forKey key: K) throws {
    if !value.isEmpty {
      try encode(value, forKey: key)
    }
  }
  
  mutating func encodeIfTrue(_ value: Bool, forKey key: K) throws {
    if value {
      try encode(value, forKey: key)
    }
  }
}
