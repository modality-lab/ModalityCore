import Testing
import ModalityCore

struct LogicalAssignmentOperatorTests {

  @Test
  func orAssign_trueOrFalse() {
    var value = true
    value ||= false
    #expect(value == true)
  }

  @Test
  func orAssign_falseOrTrue() {
    var value = false
    value ||= true
    #expect(value == true)
  }

  @Test
  func orAssign_falseOrFalse() {
    var value = false
    value ||= false
    #expect(value == false)
  }

  @Test
  func andAssign_trueAndTrue() {
    var value = true
    value &&= true
    #expect(value == true)
  }

  @Test
  func andAssign_trueAndFalse() {
    var value = true
    value &&= false
    #expect(value == false)
  }

  @Test
  func nilCoalescingAssign_setsWhenNil() {
    var value: Int? = nil
    value ??= 42
    #expect(value == 42)
  }

  @Test
  func nilCoalescingAssign_preservesExisting() {
    var value: Int? = 10
    value ??= 42
    #expect(value == 10)
  }
}
