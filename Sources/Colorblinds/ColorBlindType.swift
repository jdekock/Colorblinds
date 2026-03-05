import simd
import CoreImage

/// The type of color blindness to simulate.
public enum ColorBlindType: String, CaseIterable, Identifiable, Sendable {
    case deuteranomaly
    case deuteranopia
    case protanomaly
    case protanopia
    case tritanomaly
    case tritanopia
    case achromatomaly
    case achromatopsia

    public var id: String { rawValue }

    /// Human-readable name for display in pickers.
    public var displayName: String {
        switch self {
        case .deuteranomaly:  return "Deuteranomaly"
        case .deuteranopia:   return "Deuteranopia"
        case .protanomaly:    return "Protanomaly"
        case .protanopia:     return "Protanopia"
        case .tritanomaly:    return "Tritanomaly"
        case .tritanopia:     return "Tritanopia"
        case .achromatomaly:  return "Achromatomaly"
        case .achromatopsia:  return "Achromatopsia"
        }
    }

    /// Short description of what this type of color blindness affects.
    public var description: String {
        switch self {
        case .deuteranomaly:  return "Reduced green sensitivity (most common)"
        case .deuteranopia:   return "No green cones"
        case .protanomaly:    return "Reduced red sensitivity"
        case .protanopia:     return "No red cones"
        case .tritanomaly:    return "Reduced blue sensitivity"
        case .tritanopia:     return "No blue cones"
        case .achromatomaly:  return "Reduced overall color sensitivity"
        case .achromatopsia:  return "Complete color blindness"
        }
    }

    /// 3x3 color transformation matrix. Each SIMD3 is one row: (R, G, B) coefficients for the output channel.
    public var matrix: (SIMD3<Float>, SIMD3<Float>, SIMD3<Float>) {
        switch self {
        case .deuteranomaly:
            return (
                SIMD3<Float>(0.80, 0.20, 0.00),
                SIMD3<Float>(0.2586, 0.7414, 0.00),
                SIMD3<Float>(0.00, 0.1420, 0.8580)
            )
        case .deuteranopia:
            return (
                SIMD3<Float>(0.625, 0.375, 0.00),
                SIMD3<Float>(0.700, 0.300, 0.00),
                SIMD3<Float>(0.00, 0.300, 0.700)
            )
        case .protanomaly:
            return (
                SIMD3<Float>(0.8170, 0.1830, 0.00),
                SIMD3<Float>(0.3330, 0.6670, 0.00),
                SIMD3<Float>(0.00, 0.1250, 0.8750)
            )
        case .protanopia:
            return (
                SIMD3<Float>(0.5667, 0.4333, 0.00),
                SIMD3<Float>(0.5585, 0.4415, 0.00),
                SIMD3<Float>(0.00, 0.2418, 0.7582)
            )
        case .tritanomaly:
            return (
                SIMD3<Float>(0.9670, 0.0330, 0.00),
                SIMD3<Float>(0.00, 0.7330, 0.2670),
                SIMD3<Float>(0.00, 0.1830, 0.8170)
            )
        case .tritanopia:
            return (
                SIMD3<Float>(0.950, 0.050, 0.00),
                SIMD3<Float>(0.00, 0.4333, 0.5667),
                SIMD3<Float>(0.00, 0.4750, 0.5250)
            )
        case .achromatomaly:
            return (
                SIMD3<Float>(0.618, 0.320, 0.062),
                SIMD3<Float>(0.163, 0.775, 0.062),
                SIMD3<Float>(0.163, 0.320, 0.516)
            )
        case .achromatopsia:
            return (
                SIMD3<Float>(0.299, 0.587, 0.114),
                SIMD3<Float>(0.299, 0.587, 0.114),
                SIMD3<Float>(0.299, 0.587, 0.114)
            )
        }
    }

    /// CIVector representations for use with CIColorMatrix filter.
    internal var ciVectors: (rVector: CIVector, gVector: CIVector, bVector: CIVector) {
        let m = matrix
        return (
            rVector: CIVector(x: CGFloat(m.0.x), y: CGFloat(m.0.y), z: CGFloat(m.0.z), w: 0),
            gVector: CIVector(x: CGFloat(m.1.x), y: CGFloat(m.1.y), z: CGFloat(m.1.z), w: 0),
            bVector: CIVector(x: CGFloat(m.2.x), y: CGFloat(m.2.y), z: CGFloat(m.2.z), w: 0)
        )
    }
}
