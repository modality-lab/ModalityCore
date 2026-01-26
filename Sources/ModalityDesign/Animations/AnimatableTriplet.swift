import SwiftUI

public struct AnimatableTriplet<First, Second, Third>: VectorArithmetic where First: VectorArithmetic, Second: VectorArithmetic, Third: VectorArithmetic {
  public var first: First
  public var second: Second
  public var third: Third

  public init(_ first: First, _ second: Second, _ third: Third) {
    self.first = first
    self.second = second
    self.third = third
  }

  public static var zero: AnimatableTriplet {
    AnimatableTriplet(.zero, .zero, .zero)
  }

  public var magnitudeSquared: Double {
    first.magnitudeSquared + second.magnitudeSquared + third.magnitudeSquared
  }

  public mutating func scale(by rhs: Double) {
    first.scale(by: rhs)
    second.scale(by: rhs)
    third.scale(by: rhs)
  }

  public static func + (lhs: AnimatableTriplet, rhs: AnimatableTriplet) -> AnimatableTriplet {
    AnimatableTriplet(lhs.first + rhs.first, lhs.second + rhs.second, lhs.third + rhs.third)
  }

  public static func += (lhs: inout AnimatableTriplet, rhs: AnimatableTriplet) {
    lhs.first += rhs.first
    lhs.second += rhs.second
    lhs.third += rhs.third
  }

  public static func - (lhs: AnimatableTriplet, rhs: AnimatableTriplet) -> AnimatableTriplet {
    AnimatableTriplet(lhs.first - rhs.first, lhs.second - rhs.second, lhs.third - rhs.third)
  }

  public static func -= (lhs: inout AnimatableTriplet, rhs: AnimatableTriplet) {
    lhs.first -= rhs.first
    lhs.second -= rhs.second
    lhs.third -= rhs.third
  }
}

extension AnimatableTriplet: Animatable {
  public var animatableData: AnimatablePair<First, AnimatablePair<Second, Third>> {
    get {
      AnimatablePair(first, AnimatablePair(second, third))
    }
    set {
      first = newValue.first
      second = newValue.second.first
      third = newValue.second.second
    }
  }
}
