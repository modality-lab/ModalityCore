infix operator ||=
public func ||= (lhs: inout Bool, rhs: @autoclosure () -> Bool) {
  lhs = (lhs || rhs())
}

infix operator &&=
public func &&= (lhs: inout Bool, rhs: @autoclosure () -> Bool) {
  lhs = (lhs && rhs())
}

infix operator +=?
public func ifTrueIncrement(lhs: inout Int, rhs: @autoclosure () -> Bool) {
  if rhs() {
    lhs += 1
  }
}

infix operator ??=
public func ??=<Value>(lhs: inout Value?, rhs: @autoclosure () -> Value) {
  if lhs == nil {
    lhs = rhs()
  }
}

