import Testing
import SwiftUI
import ModalityDesign
import ModalityCore

// MARK: - AnimatableTriplet Tests

struct AnimatableTripletTests {

  @Test
  func zero() {
    let zero = AnimatableTriplet<Double, Double, Double>.zero
    #expect(zero.first == 0)
    #expect(zero.second == 0)
    #expect(zero.third == 0)
  }

  @Test
  func addition() {
    let a = AnimatableTriplet(1.0, 2.0, 3.0)
    let b = AnimatableTriplet(4.0, 5.0, 6.0)
    let result = a + b
    #expect(result.first == 5.0)
    #expect(result.second == 7.0)
    #expect(result.third == 9.0)
  }

  @Test
  func subtraction() {
    let a = AnimatableTriplet(10.0, 20.0, 30.0)
    let b = AnimatableTriplet(3.0, 5.0, 7.0)
    let result = a - b
    #expect(result.first == 7.0)
    #expect(result.second == 15.0)
    #expect(result.third == 23.0)
  }

  @Test
  func scale() {
    var triplet = AnimatableTriplet(2.0, 4.0, 6.0)
    triplet.scale(by: 3.0)
    #expect(triplet.first == 6.0)
    #expect(triplet.second == 12.0)
    #expect(triplet.third == 18.0)
  }

  @Test
  func magnitudeSquared() {
    let triplet = AnimatableTriplet(3.0, 4.0, 0.0)
    #expect(triplet.magnitudeSquared == 25.0)
  }

  @Test
  func addAssign() {
    var a = AnimatableTriplet(1.0, 2.0, 3.0)
    a += AnimatableTriplet(10.0, 20.0, 30.0)
    #expect(a.first == 11.0)
    #expect(a.second == 22.0)
    #expect(a.third == 33.0)
  }

  @Test
  func subtractAssign() {
    var a = AnimatableTriplet(10.0, 20.0, 30.0)
    a -= AnimatableTriplet(1.0, 2.0, 3.0)
    #expect(a.first == 9.0)
    #expect(a.second == 18.0)
    #expect(a.third == 27.0)
  }
}

// MARK: - Ring Tests

struct RingTests {

  @Test
  func outerRadius() {
    let ring = Ring<String>(
      id: "test",
      wedges: [],
      innerRadius: 0.2,
      height: 0.1
    )
    #expect(ring.outerRadius ~~== 0.3)
    #expect(ring.innerRadius == 0.2)
    #expect(ring.height == 0.1)
  }

  @Test
  func wedgeAngles() {
    let wedge = Ring<String>.Wedge(
      id: "w1",
      color: .red,
      start: .degrees(0),
      width: .degrees(30),
      content: .init(type: .label, containing: "A", font: .body, text: "A")
    )
    #expect(abs(wedge.end.degrees - 30) ~~== 0.0)
    #expect(abs(wedge.center.degrees - 15) ~~== 0.0)
  }

  @Test
  func wedgeEquality() {
    let a = Ring<String>.Wedge(
      id: "w1",
      color: .red,
      start: .degrees(0),
      width: .degrees(30),
      content: .init(type: .label, containing: "A", font: .body, text: "A")
    )
    let b = Ring<String>.Wedge(
      id: "w1",
      color: .red,
      start: .degrees(0),
      width: .degrees(30),
      content: .init(type: .label, containing: "A", font: .body, text: "A")
    )
    #expect(a == b)
  }
}

// MARK: - VioletPalette Tests

struct VioletPaletteTests {

  @Test
  func rampHasTenColors() {
    #expect(VioletPalette.violetRamp.count == 10)
  }

  @Test
  func rampStartsDark() {
    let first = VioletPalette.violetRamp.first!
    let last = VioletPalette.violetRamp.last!
    #expect(first.components.red + first.components.green + first.components.blue <
            last.components.red + last.components.green + last.components.blue)
  }
}

// MARK: - Color Hex Init Tests

struct ColorHexTests {

  @Test
  func whiteFromHex() {
    let white = Color(0xFFFFFF)
    let components = white.components
    #expect(abs(components.red - 1.0) ~~== 0.0)
    #expect(abs(components.green - 1.0) ~~== 0.0)
    #expect(abs(components.blue - 1.0) ~~== 0.0)
  }

  @Test
  func blackFromHex() {
    let black = Color(0x000000)
    let components = black.components
    #expect(abs(components.red) ~~< 0.01)
    #expect(abs(components.green) ~~< 0.01)
    #expect(abs(components.blue) ~~< 0.01)
  }

  @Test
  func redFromHex() {
    let red = Color(0xFF0000)
    let components = red.components
    #expect(abs(components.red - 1.0) ~~== 0.0)
    #expect(abs(components.green) ~~== 0.0)
    #expect(abs(components.blue) ~~== 0.0)
  }
}

// MARK: - Color VectorArithmetic Tests

struct ColorVectorArithmeticTests {

  @Test
  func colorAdditionClamps() {
    let white = Color(red: 1, green: 1, blue: 1)
    let result = white + white
    let c = result.components
    #expect(c.red <= 1.0)
    #expect(c.green <= 1.0)
    #expect(c.blue <= 1.0)
  }

  @Test
  func colorSubtractionClamps() {
    let black = Color(red: 0, green: 0, blue: 0)
    let white = Color(red: 1, green: 1, blue: 1)
    let result = black - white
    let c = result.components
    #expect(c.red >= 0.0)
    #expect(c.green >= 0.0)
    #expect(c.blue >= 0.0)
  }

  @Test
  func zeroIsBlack() {
    let zero = Color.zero
    let c = zero.components
    #expect(abs(c.red) ~~== 0.0)
    #expect(abs(c.green) ~~== 0.0)
    #expect(abs(c.blue) ~~== 0.0)
  }
}
