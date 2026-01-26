import SwiftUI

public struct ErrorPopupView: View {
  
  public let title: String?
  public let description: String?
  public let onTryAgain: () -> Void
  
  public init(
    title: String? = nil,
    description: String? = nil,
//    onCustomerService: () -> Void,
    onTryAgain: @escaping () -> Void
  ) {
    self.title = title
    self.description = description
    self.onTryAgain = onTryAgain
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      if let title {
        Text(title)
          .multilineTextAlignment(.center)
          .lineLimit(nil)
          .font(.title3.bold())
          .foregroundColor(.primary)
      }
      
      if let description {
        Text(description)
          .multilineTextAlignment(.center)
          .lineLimit(nil)
          .font(.system(size: 12))
          .padding(.top, 4)
      }
      
      Button(action: onTryAgain) {
        Text("Try Again")
          .padding(.horizontal, 24)
          .padding(.vertical, 8)
          .background(Color.primaryPurple)
          .foregroundColor(.white)
          .cornerRadius(6)
          .padding(.top, 16)
      }.buttonStyle(.plain)
    }
    .padding(.horizontal, 24)
    .padding(.vertical, 16)
    .background {
      RoundedRectangle(cornerRadius: 20)
        .fill(Color.backgroundColor)
        .overlay {
          RoundedRectangle(cornerRadius: 20)
            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        }
    }
    .frame(maxWidth: 320)
  }
}

#if DEBUG
#Preview {
  ErrorPopupView(
    title: "Unable to load charts data",
    description: "Please, try again later",
    onTryAgain: {}
  )
  .padding(100)
  .background(Color.backgroundColor)
}
#endif
