import SwiftUI

#if DEBUG
public extension Color {
  static var randomColor: Color {
    Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1)).opacity(0.6)
  }
}

public extension View {
  var randomColorOverlay: some View {
    overlay { Color.randomColor }
  }
  
  var randomColorBorder: some View {
    overlay(Rectangle().stroke(Color.randomColor, lineWidth: 1))
  }
}
#endif
