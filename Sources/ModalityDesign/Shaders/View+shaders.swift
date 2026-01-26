import SwiftUI

extension View {

  @ViewBuilder
  public var invertEffectIfAvailable: some View {
    if #available(macOS 14.0, iOS 17.0, *) {
      colorEffect(Shader(function: ShaderFunction(library: .bundle(.module), name: "invert"), arguments: []))
    } else {
      self
    }
  }

  @ViewBuilder
  public func parameterizedNoiseIfAvailable(intensity: Double, frequency: Double, opacity: Double) -> some View {
    if #available(macOS 14.0, iOS 17.0, *) {
      colorEffect(
        Shader(
          function: ShaderFunction(library: .bundle(.module), name: "parameterizedNoise"),
          arguments: [.float(intensity), .float(frequency), .float(opacity)]
        )
      )
    } else {
      self
    }
  }
}
