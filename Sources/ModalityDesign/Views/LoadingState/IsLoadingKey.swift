import SwiftUI

private struct IsLoadingKey: EnvironmentKey { static let defaultValue = false }

public extension EnvironmentValues {
  var isLoading: Bool {
    get { self[IsLoadingKey.self] }
    set { self[IsLoadingKey.self] = newValue }
  }
}
