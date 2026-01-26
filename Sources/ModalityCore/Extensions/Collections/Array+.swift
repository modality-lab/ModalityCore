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
  public func max<Value: Comparable>(_ ketPath: KeyPath<Element, Value>) -> Value? {
    self.max(by: { $0[keyPath: ketPath] < $1[keyPath: ketPath] })?[keyPath: ketPath]
  }
  
  public func min<Value: Comparable>(_ ketPath: KeyPath<Element, Value>) -> Value? {
    self.min(by: { $0[keyPath: ketPath] < $1[keyPath: ketPath] })?[keyPath: ketPath]
  }
}

// MARK: - Statistical Functions
extension Array where Element: BinaryFloatingPoint {
  
  public var average: Element {
    guard !isEmpty else { return 0 }
    return sum / Element(count)
  }
  
  public var median: Element {
    guard !isEmpty else { return 0 }
    let sorted = self.sorted()
    let count = sorted.count
    
    if count % 2 == 0 {
      // Even number of elements - average of two middle values
      let mid1 = sorted[count / 2 - 1]
      let mid2 = sorted[count / 2]
      return (mid1 + mid2) / 2
    } else {
      // Odd number of elements - middle value
      return sorted[count / 2]
    }
  }
  
  public var sum: Element {
    reduce(0, +)
  }
}

extension Array {
  
  // TODO: Optimize
  public func average<Value: BinaryFloatingPoint>(_ keyPath: KeyPath<Element, Value>) -> Value {
    map { $0[keyPath: keyPath] }.average
  }
  
  public func median<Value: BinaryFloatingPoint>(_ keyPath: KeyPath<Element, Value>) -> Value {
    map { $0[keyPath: keyPath] }.median
  }
  
  public func sum<Value: BinaryFloatingPoint>(_ keyPath: KeyPath<Element, Value>) -> Value {
    map { $0[keyPath: keyPath] }.sum
  }
}


extension Array {
  public func chunked(into size: Int) -> [[Element]] {
    return stride(from: 0, to: count, by: size).map {
      Array(self[$0..<Swift.min($0 + size, count)])
    }
  }
}
