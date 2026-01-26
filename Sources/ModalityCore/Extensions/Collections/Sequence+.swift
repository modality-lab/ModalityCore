public extension Sequence {
  var array: [Element] {
    Array(self)
  }
}

public extension Sequence where Element: Hashable {
  func uniqued() -> [Element] {
    var set = Set<Element>()
    return filter { set.insert($0).inserted }
  }
}
