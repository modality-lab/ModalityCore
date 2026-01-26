import SwiftUI

#if DEBUG
public extension Color {
  static var debug: Color {
    Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1)).opacity(0.6)
  }
}

public extension View {
  var debug: some View {
    overlay { Color.debug }
  }
  
  var debugBorder: some View {
    overlay(Rectangle().stroke(Color.debug, lineWidth: 1))
  }
}
#endif
