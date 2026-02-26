import Foundation

extension Array: @retroactive RawRepresentable where Element: Codable {
  public init?(rawValue: String) {
    guard let data = rawValue.data(using: .utf8),
          let result = try? JSONDecoder().decode([Element].self, from: data)
    else {
      return nil
    }
    self = result
  }
  
  public var rawValue: String {
    guard let data = try? JSONEncoder().encode(self),
          let result = String(data: data, encoding: .utf8)
    else {
      return "[]"
    }
    return result
  }
}

extension Array {
  public func max<Value: Comparable>(_ keyPath: KeyPath<Element, Value>) -> Value? {
    self.max(by: { $0[keyPath: keyPath] < $1[keyPath: keyPath] })?[keyPath: keyPath]
  }

  public func min<Value: Comparable>(_ keyPath: KeyPath<Element, Value>) -> Value? {
    self.min(by: { $0[keyPath: keyPath] < $1[keyPath: keyPath] })?[keyPath: keyPath]
  }
}

// MARK: - Statistical Functions
extension Array where Element: BinaryFloatingPoint {
  public var average: Element { average(\.self) }
  public var median: Element { median(\.self) }
  public var sum: Element { sum(\.self) }
}

extension Array {
  
  public func average<Value: BinaryFloatingPoint>(_ keyPath: KeyPath<Element, Value>) -> Value {
    guard !isEmpty else { return 0 }
    return sum(keyPath) / Value(count)
  }
  
  public func median<Value: BinaryFloatingPoint>(_ keyPath: KeyPath<Element, Value>) -> Value {
    guard !isEmpty else { return 0 }
    let sorted = lazy.map { $0[keyPath: keyPath] }.sorted()
    let mid = count / 2
    return count.isMultiple(of: 2) ? (sorted[mid - 1] + sorted[mid]) / 2 : sorted[mid]
  }
  
  public func sum<Value: BinaryFloatingPoint>(_ keyPath: KeyPath<Element, Value>) -> Value {
    reduce(0) { $0 + $1[keyPath: keyPath] }
  }
}


extension Array {
  public func chunked(into size: Int) -> [[Element]] {
    return stride(from: 0, to: count, by: size).map {
      Array(self[$0..<Swift.min($0 + size, count)])
    }
  }
}
