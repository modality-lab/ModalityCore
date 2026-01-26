public struct SeededRandomNumberGenerator: RandomNumberGenerator {
  private var state: UInt64
  
  public init(seed: UInt64) {
    self.state = seed
  }
  
  public mutating func next() -> UInt64 {
    // LCG: Numerical Recipes constants
    state = state &* 6364136223846793005 &+ 1442695040888963407
    return state
  }
}


