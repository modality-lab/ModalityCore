import Testing
import ModalityCore

struct LerpTests {

  @Test
  func lerpAtZero() {
    let result = 0.0.lerp(from: 10, to: 20)
    #expect(result == 10.0)
  }

  @Test
  func lerpAtOne() {
    let result = 1.0.lerp(from: 10, to: 20)
    #expect(result == 20.0)
  }

  @Test
  func lerpAtHalf() {
    let result = 0.5.lerp(from: 0, to: 100)
    #expect(result == 50.0)
  }

  @Test
  func lerpExtrapolates() {
    let result = 2.0.lerp(from: 0, to: 10)
    #expect(result == 20.0)
  }
}

struct NormalizeTests {

  @Test
  func normalizeMiddle() {
    let result = 50.0.normalize(from: 0, to: 100)
    #expect(result == 0.5)
  }

  @Test
  func normalizeAtMin() {
    let result = 0.0.normalize(from: 0, to: 100)
    #expect(result == 0.0)
  }

  @Test
  func normalizeAtMax() {
    let result = 100.0.normalize(from: 0, to: 100)
    #expect(result == 1.0)
  }

  @Test
  func normalizeInvalidRange() {
    let result = 50.0.normalize(from: 100, to: 0)
    #expect(result == -1)
  }

  @Test
  func normalizeInteger() {
    let result = 5.normalize(from: 0, to: 10)
    #expect(result == 0.5)
  }
}

struct DoubleExtensionTests {

  @Test
  func int() {
    #expect(3.7.int == 3)
    #expect((-1.2).int == -1)
  }

  @Test
  func f2() {
    #expect(3.14159.f2 == "3.14")
  }

  @Test
  func f6() {
    #expect(3.14159.f6 == "3.141590")
  }

  @Test
  func signValue() {
    #expect(5.0.signValue == 1)
    #expect((-3.0).signValue == -1)
    #expect(0.0.signValue == 0)
  }
}
