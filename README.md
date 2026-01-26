# ModalityCore

A Swift package providing core utilities and design components for building music-related iOS, macOS, and visionOS applications.

## Products

This package provides two products:

### ModalityCore

Foundation utilities and extensions:

- **Extensions**: Array, Collection, Dictionary, Sequence manipulations
- **Audio Extensions**: AudioUnit sample rate helpers, Time utilities
- **Foundation Extensions**: Date, String, Double, Task, Logger, and more
- **Operators**: Approximate comparison operators (`~~==`, `~~!=`, `~~<`, etc.), CGSize math, logical assignments
- **Models**: Spiral data structure for circular/spiral-based visualizations
- **Utilities**: SeededRandomNumberGenerator, debug fatal error helpers

### ModalityDesign

SwiftUI design components and utilities:

- **Animations**: Custom transitions, animatable value triplets
- **Colors**: Note colors, palette definitions, hex color support, saturation adjustments
- **Fonts**: Typography definitions
- **Layouts**: TagsLayout, WidthDrivenVStack
- **Shapes**: WedgeShape, RoundedCornersRectangle, PlayheadShape, and more
- **Shaders**: Metal shaders (invert, parameterized noise)
- **Views**: Buttons, Knobs, Sliders, Ring views, Wedge views, Loading/Error states, CustomizableSegmentedControl
- **Utility**: Observable+Combine bridging, WindowAccessor

## Requirements

- iOS 16.0+
- macOS 13.0+
- visionOS 1.0+
- Swift 5.9+

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
  .package(url: "https://github.com/modality-lab/ModalityCore.git", from: "1.0.0"),
]
```

Then add products to your target:

```swift
.target(
  name: "YourTarget",
  dependencies: [
    .product(name: "ModalityCore", package: "ModalityCore"),
    .product(name: "ModalityDesign", package: "ModalityCore"),
  ]
)
```

## License

MIT License
