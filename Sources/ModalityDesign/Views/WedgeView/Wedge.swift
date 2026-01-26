import Foundation
import SwiftUI
import ModalityCore

extension Ring {
  public struct Wedge: Identifiable, Hashable {
    
    public struct Content: Hashable {
      public enum ContentType: Hashable {
        case label
        case circularLabel
      }

      let type: ContentType
      let font: Font
      let text: String
      public let containing: Containing
      
      public init(type: ContentType, containing: Containing, font: Font, text: String) {
        self.type = type
        self.containing = containing
        self.font = font
        self.text = text
      }
    }
    
    // TODO: refactor id
    public var id: String

    public private(set) var color: Color
    public private(set) var start: Angle
    public private(set) var width: Angle
    
    public let zIndex: Double

    public var end: Angle { start + width }
    public var center: Angle { start + width / 2 }
    
    public let isFocused: Bool
    
    public let content: Content
    
    public init(
      id: String,
      color: Color,
      start: Angle,
      width: Angle,
      zIndex: Double = 0,
      content: Content,
      isFocused: Bool = true
    ) {
      self.id = id
      self.color = color
      self.start = start
      self.width = width
      self.zIndex = zIndex
      self.content = content
      self.isFocused = isFocused
    }
  }
}

extension Ring.Wedge: Equatable { }

extension Ring.Wedge: Animatable {

  public var animatableData: AnimatableTriplet<Double, Double, Color> {
    get {
      .init(start.degrees, width.degrees, color)
    } set {
      start = .degrees(newValue.first)
      width = .degrees(newValue.second)
      color = newValue.third
    }
  }
}

extension Ring.Wedge {
  
  var edgeColor: Color {
    color.opacity(0.95)
//    Color(hue: hue, saturation: 0.6, brightness: 0.65, opacity: 0.8)
  }

  var centerColor: Color {
    color
//    Color(hue: hue, saturation: 0.6, brightness: 0.7, opacity: 0.8)
  }
}
