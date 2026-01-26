import SwiftUI

/// Layout value key to mark views that should drive the container's width
private struct WidthDriverKey: LayoutValueKey {
  static let defaultValue: Bool = false
}

/// Extension to allow views to specify they should drive the layout width
public extension View {
  func widthDriver(_ drives: Bool = true) -> some View {
    layoutValue(key: WidthDriverKey.self, value: drives)
  }
}

/// A layout that sizes itself based on designated width-driving children,
/// then constrains all children to that calculated width.
/// Use `.widthDriver()` modifier on views that should determine the container width.
/// Falls back to first child if no width drivers are specified.
public struct WidthDrivenVStack: Layout {
  let minWidth: CGFloat
  let maxWidth: CGFloat
  let spacing: CGFloat
  let alignment: HorizontalAlignment
  
  public init(
    minWidth: CGFloat = 0,
    maxWidth: CGFloat = .infinity,
    spacing: CGFloat = 0,
    alignment: HorizontalAlignment = .leading
  ) {
    self.minWidth = minWidth
    self.maxWidth = maxWidth
    self.spacing = spacing
    self.alignment = alignment
  }
  
  public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
    guard !subviews.isEmpty else { return .zero }
    
    // Find width drivers or fall back to first view
    let widthDrivers = subviews.filter { $0[WidthDriverKey.self] }
    let drivingViews = widthDrivers.isEmpty ? [subviews.first!] : widthDrivers
    
    // Calculate the maximum width needed by all driving views
    let drivingWidth = drivingViews.map { $0.sizeThatFits(.unspecified).width }.max() ?? 0
    let constrainedWidth = max(minWidth, min(maxWidth, drivingWidth))
    
    // Calculate total height
    var totalHeight: CGFloat = 0
    let constrainedProposal = ProposedViewSize(width: constrainedWidth, height: nil)
    
    for (index, subview) in subviews.enumerated() {
      let size = subview.sizeThatFits(constrainedProposal)
      totalHeight += size.height
      
      // Add spacing between views (but not after the last one)
      if index < subviews.count - 1 {
        totalHeight += spacing
      }
    }
    
    return CGSize(width: constrainedWidth, height: totalHeight)
  }
  
  public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
    guard !subviews.isEmpty else { return }
    
    // Find width drivers or fall back to first view
    let widthDrivers = subviews.filter { $0[WidthDriverKey.self] }
    let drivingViews = widthDrivers.isEmpty ? [subviews.first!] : widthDrivers
    
    // Calculate the maximum width needed by all driving views
    let drivingWidth = drivingViews.map { $0.sizeThatFits(.unspecified).width }.max() ?? 0
    let constrainedWidth = max(minWidth, min(maxWidth, drivingWidth))
    let constrainedProposal = ProposedViewSize(width: constrainedWidth, height: nil)
    
    var currentY = bounds.minY
    
    for subview in subviews {
      let size = subview.sizeThatFits(constrainedProposal)
      
      let xPosition: CGFloat
      switch alignment {
      case .leading:
        xPosition = bounds.minX
      case .center:
        xPosition = bounds.minX + (constrainedWidth - size.width) / 2
      case .trailing:
        xPosition = bounds.minX + constrainedWidth - size.width
      default:
        xPosition = bounds.minX
      }
      
      subview.place(
        at: CGPoint(x: xPosition, y: currentY),
        proposal: constrainedProposal
      )
      
      currentY += size.height + spacing
    }
  }
}

#Preview {
  VStack(spacing: 20) {
    // Example 1: Text drives width
    WidthDrivenVStack(
      minWidth: 100,
      maxWidth: 250,
      spacing: 8,
      alignment: .leading
    ) {
      Text("This title drives the width")
        .font(.headline)
        .lineLimit(2)
        .widthDriver() // Mark as width driver
      
      HStack {
        ForEach(["tag1", "tag2", "very long tag name"], id: \.self) { tag in
          Text(tag)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.gray.opacity(0.2))
            .clipShape(Capsule())
        }
      }
    }
    .padding()
    .border(Color.red)
    
    // Example 2: Multiple width drivers (takes max)
    WidthDrivenVStack(
      minWidth: 100,
      maxWidth: 300,
      spacing: 8
    ) {
      Text("Short")
        .font(.headline)
        .widthDriver()
      
      Text("This is a much longer piece of text that should drive the width")
        .font(.caption)
        .widthDriver()
      
      Button("Constrained Button") { }
        .buttonStyle(.borderedProminent)
    }
    .padding()
    .border(Color.blue)
  }
} 