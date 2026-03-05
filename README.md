# Colorblinds

A Swift Package for simulating color blindness in iOS apps. Uses GPU-accelerated color transformation for real-time, full frame rate simulation.

## Requirements

- iOS 17+
- Swift 5.9+

## Installation

Add Colorblinds to your project via Swift Package Manager:

```
https://github.com/jdekock/Colorblinds
```

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/dekock/Colorblinds", from: "1.0.0")
]
```

## Usage

### SwiftUI

**Apply a specific simulation:**

```swift
import Colorblinds

struct ContentView: View {
    var body: some View {
        MyAppView()
            .colorBlindSimulation(.deuteranopia)
    }
}
```

**Bind to an optional type** (nil removes the filter):

```swift
@State private var selectedType: ColorBlindType?

var body: some View {
    MyAppView()
        .colorBlindSimulation(selectedType)
}
```

**Full simulator experience** — triple-tap anywhere to open a picker sheet:

```swift
var body: some View {
    MyAppView()
        .colorBlindSimulator()
}
```

> **Note:** Apply the modifier to your content views rather than to a `NavigationStack` or `TabView`. These container views use internal rendering (e.g. navigation bar materials) that conflicts with the Metal shader, resulting in a yellow warning screen.

### UIKit

**Full simulator experience** — call `start` with your app's window, then triple-tap to open a picker:

```swift
import Colorblinds

func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options: UIScene.ConnectionOptions) {
    guard let windowScene = scene as? UIWindowScene,
          let window = windowScene.windows.first else { return }

    ColorBlindOverlay.shared.start(in: window)
}
```

**Direct control:**

```swift
// Apply a specific simulation
ColorBlindOverlay.shared.simulate(.protanopia, in: window)

// Remove the simulation
ColorBlindOverlay.shared.stop()
```

## Supported Types

| Type | Description |
|---|---|
| `deuteranomaly` | Reduced green sensitivity (most common) |
| `deuteranopia` | No green cones |
| `protanomaly` | Reduced red sensitivity |
| `protanopia` | No red cones |
| `tritanomaly` | Reduced blue sensitivity |
| `tritanopia` | No blue cones |
| `achromatomaly` | Reduced overall color sensitivity |
| `achromatopsia` | Complete color blindness |

## How It Works

- **SwiftUI** — Uses a `[[stitchable]]` Metal shader via `.colorEffect()`, running directly in SwiftUI's render pipeline. No screen capture, no overlay. Truly live at full frame rate.
- **UIKit** — Uses `CADisplayLink` to capture the window's layer, applies a `CIColorMatrix` filter on the GPU, and renders the result to an `MTKView` overlay.

## License

MIT
