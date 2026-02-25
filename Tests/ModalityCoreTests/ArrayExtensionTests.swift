import Testing
import ModalityCore

struct ArrayStatisticsTests {

  @Test
  func average() {
    let values: [Double] = [10, 20, 30]
    #expect(values.average == 20.0)
  }

  @Test
  func averageEmpty() {
    let values: [Double] = []
    #expect(values.average == 0)
  }

  @Test
  func median_odd() {
    let values: [Double] = [3, 1, 2]
    #expect(values.median == 2.0)
  }

  @Test
  func median_even() {
    let values: [Double] = [4, 1, 3, 2]
    #expect(values.median == 2.5)
  }

  @Test
  func medianEmpty() {
    let values: [Double] = []
    #expect(values.median == 0)
  }

  @Test
  func sum() {
    let values: [Double] = [1, 2, 3, 4]
    #expect(values.sum == 10.0)
  }

  @Test
  func chunked() {
    let values = [1, 2, 3, 4, 5]
    let chunks = values.chunked(into: 2)
    #expect(chunks.count == 3)
    #expect(chunks[0] == [1, 2])
    #expect(chunks[1] == [3, 4])
    #expect(chunks[2] == [5])
  }

  @Test
  func chunkedExact() {
    let values = [1, 2, 3, 4]
    let chunks = values.chunked(into: 2)
    #expect(chunks.count == 2)
    #expect(chunks[0] == [1, 2])
    #expect(chunks[1] == [3, 4])
  }
}

struct ArrayKeyPathTests {

  struct Item { let value: Double; let name: String }

  @Test
  func maxByKeyPath() {
    let items = [Item(value: 10, name: "a"), Item(value: 30, name: "b"), Item(value: 20, name: "c")]
    #expect(items.max(\.value) == 30.0)
  }

  @Test
  func minByKeyPath() {
    let items = [Item(value: 10, name: "a"), Item(value: 30, name: "b"), Item(value: 20, name: "c")]
    #expect(items.min(\.value) == 10.0)
  }

  @Test
  func maxEmptyArray() {
    let items: [Item] = []
    #expect(items.max(\.value) == nil)
  }

  @Test
  func averageByKeyPath() {
    let items = [Item(value: 10, name: "a"), Item(value: 20, name: "b"), Item(value: 30, name: "c")]
    #expect(items.average(\.value) == 20.0)
  }

  @Test
  func sumByKeyPath() {
    let items = [Item(value: 10, name: "a"), Item(value: 20, name: "b")]
    #expect(items.sum(\.value) == 30.0)
  }

  @Test
  func medianByKeyPath() {
    let items = [Item(value: 30, name: "a"), Item(value: 10, name: "b"), Item(value: 20, name: "c")]
    #expect(items.median(\.value) == 20.0)
  }
}

struct ArrayRawRepresentableTests {

  @Test
  func roundTrip() {
    let original = [1, 2, 3]
    let raw = original.rawValue
    let decoded = [Int](rawValue: raw)
    #expect(decoded == original)
  }

  @Test
  func emptyArray() {
    let original: [Int] = []
    let raw = original.rawValue
    #expect(raw == "[]")
    let decoded = [Int](rawValue: raw)
    #expect(decoded == [])
  }

  @Test
  func invalidRawValue() {
    let decoded = [Int](rawValue: "not json")
    #expect(decoded == nil)
  }
}
