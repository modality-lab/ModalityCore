infix operator ~~== : ComparisonPrecedence
infix operator ~~!= : ComparisonPrecedence
infix operator ~~<  : ComparisonPrecedence
infix operator ~~>  : ComparisonPrecedence
infix operator ~~<= : ComparisonPrecedence
infix operator ~~>= : ComparisonPrecedence

@inlinable
func _tol<T: BinaryFloatingPoint>(_ a: T, _ b: T, ulps: T = 16) -> T {
  // relative tolerance: ulps * ULP at the larger magnitude
  let rel = ulps * max(a.magnitude, b.magnitude) * T.ulpOfOne
  // absolute floor: ulps * ULP at 1.0 (works well near zero)
  let absFloor = ulps * T.ulpOfOne
  return max(rel, absFloor)
}

public func ~~==<T: BinaryFloatingPoint>(_ a: T, _ b: T) -> Bool {
  abs(a - b) <= _tol(a, b)
}

public func ~~!=<T: BinaryFloatingPoint>(_ a: T, _ b: T) -> Bool {
  !(a ~~== b)
}

public func ~~<<T: BinaryFloatingPoint>(_ a: T, _ b: T) -> Bool {
  // strictly less only if below by more than tolerance
  (b - a) > _tol(a, b)
}

public func ~~><T: BinaryFloatingPoint>(_ a: T, _ b: T) -> Bool {
  // strictly greater only if above by more than tolerance
  (a - b) > _tol(a, b)
}

public func ~~<=<T: BinaryFloatingPoint>(_ a: T, _ b: T) -> Bool {
  (a ~~< b) || (a ~~== b)
}

public func ~~>=<T: BinaryFloatingPoint>(_ a: T, _ b: T) -> Bool {
  (a ~~> b) || (a ~~== b)
}

