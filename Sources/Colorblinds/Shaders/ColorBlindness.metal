#include <metal_stdlib>
using namespace metal;

[[stitchable]] half4 colorBlindness(float2 position, half4 color,
                                     float3 row0, float3 row1, float3 row2) {
    // Skip fully transparent pixels
    if (color.a <= 0.0h) {
        return color;
    }

    // Unpremultiply alpha
    half3 rgb = color.rgb / color.a;

    // Apply 3x3 color transformation matrix via dot products
    half3 transformed = half3(
        dot(half3(row0), rgb),
        dot(half3(row1), rgb),
        dot(half3(row2), rgb)
    );

    // Clamp to valid range and re-premultiply alpha
    transformed = clamp(transformed, 0.0h, 1.0h);
    return half4(transformed * color.a, color.a);
}
