import SwiftUI
import os
import SwiftMusicTheory

public struct Spiral<Element: Sendable>: Sendable {

  // MARK: - Public

  public var spiralTurnLength: Int
  public let elements: [Element]

  public init(elements: [Element], spiralTurnLength: Int) {
    self.elements = elements
    self.spiralTurnLength = spiralTurnLength
  }

  public func projection(from fromIndex: Int) -> [Element] {
    var result = [Element]()

    let turnIndex = fromIndex / spiralTurnLength
    let elementIndex = fromIndex % spiralTurnLength

    for projectedIndex in 0..<spiralTurnLength {
      let currentTurnIndex = projectedIndex + spiralTurnLength * turnIndex
      let nextTurnIndex = currentTurnIndex + spiralTurnLength
      let fromNextTurn = projectedIndex < elementIndex && nextTurnIndex < elements.count

      result.append(elements[fromNextTurn ? nextTurnIndex : currentTurnIndex])
    }

    return result
  }
}

public extension Spiral<Note> {
  static var withTripleAlterations: Spiral<Note> {
    Spiral<Note>(
      elements: {
        var notes = [Note.f.flat(3)]
        for noteIndex in (1..<49) { // 7 natural notes, 7 flats/sharps, 7 double flats/sharps, 7 triple
          notes.append(notes[noteIndex-1] + .fifth())
        }
        return notes
      }(),
      spiralTurnLength: Interval.octave().semitonesCount()
    )
  }
}
