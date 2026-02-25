# ModalityCore

![Version](https://img.shields.io/github/v/release/modality-lab/ModalityCore)
![Swift](https://img.shields.io/badge/Swift-5.9+-orange?logo=swift)
![Platforms](https://img.shields.io/badge/Platforms-iOS%2016%20%7C%20macOS%2013%20%7C%20visionOS%201-blue)
![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen)

A Swift package providing core utilities and design components for building music-related iOS, macOS, and visionOS applications.

## Products

This package provides two products:
### ModalityCore

Foundation utilities and extensions:

- **Array Extensions**: KeyPath-based aggregations (`max`, `min`, `average`, `median`, `sum`), `chunked`, Codable `RawRepresentable` conformance
- **Approximate Comparison**: Floating-point operators (`~~==`, `~~!=`, `~~<`, `~~>`, `~~<=`, `~~>=`) with ULP-based tolerance
- **Numeric Extensions**: Interpolation, extrapolation (`lerp`), normalization, formatting, sign value
- **Property Wrappers**: `@Persisted` — automatic UserDefaults sync with debouncing
- **Operators**: CGSize arithmetic, logical assignment operators (`||=`, `&&=`, `??=`)
- **Utilities**: `SeededRandomNumberGenerator`, debug helpers, Logger extensions

### ModalityDesign

SwiftUI design components and utilities:

- **Views**: `RangeRestrictedSlider`, `Knob`, `WedgeView`, `RingView`, `CircularLabel`, `TagsView`, `WindowOpenableButton`
- **Layouts**: `TagsLayout` (wrapping flow layout), `WidthDrivenVStack`
- **Shapes**: `WedgeShape`, `RoundedCornersRectangle`, `PlayheadShape`
- **Shaders**: Metal shaders (invert, parameterized noise)
- **Animations**: Custom transitions, `AnimatableTriplet`

## Usage

### Approximate Comparison

Standard floating-point comparison fails for accumulated rounding errors. The approximate operators handle this:

```swift
import ModalityCore

var value: Double = 1.0
for _ in 0..<10 { value -= 0.1 }

value == 0.0   // false (floating-point drift)
value ~~== 0.0 // true  (within ULP tolerance)
value ~~!= 0.0 // false
value ~~<= 0.0 // true
```

### KeyPath Aggregations

```swift
import ModalityCore

struct Score { let value: Double; let weight: Double }
let scores = [Score(value: 85, weight: 1.0), Score(value: 92, weight: 1.5)]

scores.max(\.value)       // 92.0
scores.average(\.value)   // 88.5
scores.sum(\.weight)      // 2.5

[1.0, 2.0, 3.0, 4.0, 5.0].median // 3.0
[10.0, 20.0, 30.0].chunked(into: 2) // [[10.0, 20.0], [30.0]]
```

### @Persisted Property Wrapper

```swift
import ModalityCore

@Persisted(key: "playbackSpeed", defaultValue: 1.0, debounce: 0.3)
var speed: Double

// Observe changes via Combine
$speed.sink { newSpeed in print("Speed: \(newSpeed)") }
```

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
  .package(url: "https://github.com/modality-lab/ModalityCore.git", branch: "main"),
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
