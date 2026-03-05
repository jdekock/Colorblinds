import SwiftUI

struct ColorBlindModifier: ViewModifier {
    let type: ColorBlindType

    func body(content: Content) -> some View {
        let m = type.matrix
        content.colorEffect(
            ShaderLibrary.bundle(Bundle.module).colorBlindness(
                .float3(m.0.x, m.0.y, m.0.z),
                .float3(m.1.x, m.1.y, m.1.z),
                .float3(m.2.x, m.2.y, m.2.z)
            )
        )
    }
}

extension View {
    /// Applies a color blindness simulation filter to the view.
    public func colorBlindSimulation(_ type: ColorBlindType) -> some View {
        modifier(ColorBlindModifier(type: type))
    }

    /// Applies a color blindness simulation filter to the view when the type is non-nil.
    public func colorBlindSimulation(_ type: ColorBlindType?) -> some View {
        Group {
            if let type {
                modifier(ColorBlindModifier(type: type))
            } else {
                self
            }
        }
    }
}
