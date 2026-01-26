// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "ModalityCore",
  platforms: [.iOS(.v16), .macOS(.v13), .visionOS(.v1)],
  products: [
    .library(name: "ModalityCore", targets: ["ModalityCore"]),
    .library(name: "ModalityDesign", targets: ["ModalityDesign"]),
  ],
  dependencies: [
    .package(url: "https://github.com/modality-lab/SwiftMusicTheory.git", branch: "main"),
  ],
  targets: [
    .target(
      name: "ModalityCore",
      dependencies: ["SwiftMusicTheory"]
    ),
    .target(
      name: "ModalityDesign",
      dependencies: ["ModalityCore", "SwiftMusicTheory"],
      resources: [.process("Resources")]
    ),
    .testTarget(name: "ModalityCoreTests", dependencies: ["ModalityCore"]),
    .testTarget(name: "ModalityDesignTests", dependencies: ["ModalityDesign"]),
  ]
)
