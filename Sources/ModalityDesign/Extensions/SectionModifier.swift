import SwiftUI

struct SectionModifier<Title: View>: ViewModifier {
  let title: Title
  let showCard: Bool
  
  func body(content: Content) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      title
      
      if showCard {
        content
          .cardBackground(backgroundColor: .cardsBackgroundColor.opacity(0.5))
      } else {
        content
      }
    }
  }
}

public extension View {
  func section<Title: View>(@ViewBuilder title: () -> Title, showCard: Bool = true) -> some View {
    modifier(SectionModifier(title: title(), showCard: showCard))
  }
  
  func section(title: String, showCard: Bool = true) -> some View {
    modifier(SectionModifier(
      title: Text(title)
        .font(.titleFont)
        .foregroundColor(.primary),
      showCard: showCard)
    )
  }
}
