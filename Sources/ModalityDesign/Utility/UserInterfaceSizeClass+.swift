import SwiftUI

@MainActor
public extension UserInterfaceSizeClass {
  static var byDefault: UserInterfaceSizeClass {
#if os(iOS)
    switch UIDevice.current.userInterfaceIdiom {
    case .phone:
      return .compact
    default:
      return .regular
    }
#else
    return .regular
#endif
  }
}
