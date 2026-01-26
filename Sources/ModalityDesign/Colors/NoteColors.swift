import SwiftMusicTheory
import ModalityCore
import SwiftUI

public struct NoteColors: Sendable {
  
  private let colors: [Note: Color]
  
  public init(spiral: Spiral<Note>) {
    self.colors = spiral
      .elements
      .enumerated()
      .makeDictionary { noteIndex, note in
        let color = Color.blue.mixed(
          with: .red,
          by: CGFloat(noteIndex) / CGFloat(spiral.elements.count)
        )
        
        return (note, color)
      }
  }
  
  public subscript (note: Note) -> Color {
    colors[note] ?? .clear
  }
}
