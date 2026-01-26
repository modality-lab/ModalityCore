import SwiftUI

public struct TagsView: View {
  
  public enum SelectionStyle {
    case notSelectable
    case selectable(Color)
    
    var isSelectable: Bool {
      switch self {
      case .selectable:
        return true
      case .notSelectable:
        return false
      }
    }
  }
  
  private let tags: [String]
  private let tagColor: Color
  private let selectionStyle: SelectionStyle
  private let alignment: HorizontalAlignment
  
  public init(
    tags: [String],
    tagColor: Color = .clear,
    selectionStyle: SelectionStyle = .notSelectable,
    alignment: HorizontalAlignment = .leading
  ) {
    self.tags = tags
    self.tagColor = tagColor
    self.selectionStyle = selectionStyle
    self.alignment = alignment
  }
  
  @State var selectedTags: Set<String> = []
  
  private func toggleSelection(for tag: String) {
    if selectedTags.contains(tag) {
      selectedTags.remove(tag)
    } else {
      selectedTags.insert(tag)
    }
  }
  
  public var body: some View {
    TagsLayout(alignment: alignment) {
      ForEach(tags, id: \.self) { tag in
        tagView(for: tag)
      }
    }
  }
  
  private func tagView(for tag: String) -> some View {
    HStack(alignment: .firstTextBaseline, spacing: TagsLayout.textSpacing) {
      Text("#")
        .font(.system(size: TagsLayout.hashTagFontSize, weight: .bold, design: .serif))
      Text(tag)
        .font(.system(size: TagsLayout.fontSize, weight: .thin, design: .monospaced))
    }
    
    .foregroundStyle(Color.secondary)
    .padding(.horizontal, TagsLayout.horizontalTextPaddings)
    .padding(.vertical, TagsLayout.verticalTextPaddings)
    .background {
      switch selectionStyle {
      case .notSelectable:
        Capsule()
          .fill(tagColor)
      case .selectable(let selectionColor):
        Capsule()
          .fill(selectedTags.contains(tag) ? selectionColor : tagColor)
      }
    }
    .fixedSize()
    .scaleEffect(selectedTags.contains(tag) ? 0.90 : 1.0)
    .gesture(
      TapGesture().onEnded({ toggleSelection(for: tag) }),
      isEnabled: selectionStyle.isSelectable
    )
    .animation(.spring(), value: selectedTags.contains(tag))
  }
}

public struct TagsLayout: Layout {
  public let alignment: HorizontalAlignment
  
  public init(alignment: HorizontalAlignment = .leading) {
    self.alignment = alignment
  }
  
  public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
    let rows = calculateRows(proposal: proposal, subviews: subviews)
    let totalHeight = rows.reduce(0) { partialResult, row in
      partialResult + row.maxHeight + (partialResult > 0 ? Self.verticalTagSpacing : 0)
    }
    let totalWidth = rows.map(\.totalWidth).max() ?? 0
    
    let finalWidth = min(totalWidth, proposal.width ?? .infinity)
    
    return CGSize(
      width: finalWidth,
      height: totalHeight
    )
  }
  
  public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
    let rows = calculateRows(proposal: proposal, subviews: subviews)
    var currentY = bounds.minY
    
    for row in rows {
      let rowWidth = row.totalWidth
      let startX: CGFloat
      
      switch alignment {
      case .leading:
        startX = bounds.minX
      case .center:
        startX = bounds.minX + (bounds.width - rowWidth) / 2
      case .trailing:
        startX = bounds.maxX - rowWidth
      default:
        startX = bounds.minX
      }
      
      var currentX = startX
      
      for item in row.items {
        let size = item.subview.sizeThatFits(.unspecified)
        item.subview.place(
          at: CGPoint(x: currentX, y: currentY + (row.maxHeight - size.height) / 2),
          proposal: ProposedViewSize(size)
        )
        currentX += size.width + Self.horizontalTagPaddings
      }
      
      currentY += row.maxHeight + Self.verticalTagSpacing
    }
  }
  
  private func calculateRows(proposal: ProposedViewSize, subviews: Subviews) -> [TagRow] {
    let availableWidth = proposal.width ?? .infinity
    var rows: [TagRow] = []
    var currentRow: [TagRowItem] = []
    var currentRowWidth: CGFloat = 0
    var currentRowMaxHeight: CGFloat = 0
    
    for subview in subviews {
      let size = subview.sizeThatFits(.unspecified)
      let itemWidth = size.width + (currentRow.isEmpty ? 0 : Self.horizontalTagPaddings)
      
      if currentRowWidth + itemWidth <= availableWidth || currentRow.isEmpty {
        currentRow.append(TagRowItem(subview: subview, size: size))
        currentRowWidth += itemWidth
        currentRowMaxHeight = max(currentRowMaxHeight, size.height)
      } else {
        if !currentRow.isEmpty {
          rows.append(TagRow(items: currentRow, totalWidth: currentRowWidth, maxHeight: currentRowMaxHeight))
        }
        currentRow = [TagRowItem(subview: subview, size: size)]
        currentRowWidth = size.width
        currentRowMaxHeight = size.height
      }
    }
    
    if !currentRow.isEmpty {
      rows.append(TagRow(items: currentRow, totalWidth: currentRowWidth, maxHeight: currentRowMaxHeight))
    }
    
    return rows
  }
}

private struct TagRowItem {
  let subview: LayoutSubview
  let size: CGSize
}

private struct TagRow {
  let items: [TagRowItem]
  let totalWidth: CGFloat
  let maxHeight: CGFloat
}

extension TagsLayout {
  static let hashTagFontSize: CGFloat = 10
  static let fontSize: CGFloat = 9
  static let textSpacing: CGFloat = 0
  
  static let horizontalTextPaddings: CGFloat = 0
  static let verticalTextPaddings: CGFloat = 1
  
  static let horizontalTagPaddings: CGFloat = 6
  static let verticalTagSpacing: CGFloat = 2
}

#Preview {
  TagsView(tags: [
    "Harmonic Minor", "Tapping", "Chord Progression", "Melody", "Rhythm", "Songwriting", "Music Theory",
    "Teqniqe", "Music Education"
  ], alignment: .leading)
  .frame(width: 750, height: 300)
}
