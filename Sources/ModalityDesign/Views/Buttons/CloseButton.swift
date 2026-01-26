import SwiftUI

public struct CloseButton: View {
  
  @Environment(\.dismiss) var dismiss
  
  public init() { }
  
  public var body: some View {
    Button(action: { dismiss() }) {
      Image(systemName: "xmark")
        .resizable()
        .font(.headline)
        .foregroundStyle(.gray)
        .frame(width: 12, height: 12)
        .padding(8)
        .background { Circle().fill(Color.gray.opacity(0.3)) }
    }
    .buttonStyle(.plain)
  }
}
