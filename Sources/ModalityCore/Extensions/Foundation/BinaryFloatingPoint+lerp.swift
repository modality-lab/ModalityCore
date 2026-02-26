public extension BinaryFloatingPoint {
  func lerp(from: Self, to: Self) -> Self {
    from + (to - from) * self
  }
}

public extension BinaryFloatingPoint {
  func normalize(from min: Self = 0, to max: Self) -> Double {
    Double(self).normalize(from: Double(min), to: Double(max))
  }
}

public extension BinaryInteger {
  func normalize(from min: Self = 0, to max: Self) -> Double {
    Double(self).normalize(from: Double(min), to: Double(max))
  }
}

public extension Double {
  func normalize(from min: Self = 0, to max: Self) -> Self {
    guard min != max else { return .nan }
    
    return (self - min) / (max - min)
  }
}
