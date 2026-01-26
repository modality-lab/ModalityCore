import ModalityCore
import SwiftMusicTheory
import Foundation
import Testing

final class ApproximateComapissonTests {
  
  @Test
  func approximateComapissonTests() async throws {
    var y: Double = 1

    // y ≈ -1.1102230246251565e-16
    for _ in 0..<10 { y -= 0.1 }
    
    #expect((y == 0.0) == false)
    
    #expect((y ~~== 0.0) == true)
    #expect((y ~~!= 0.0) == false)
    #expect((y ~~>  0.0) == false)
    #expect((y ~~<  0.0) == false)
    #expect((y ~~<= 0.0) == true)
    #expect((y ~~>= 0.0) == true)
  }
}
