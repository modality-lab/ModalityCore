#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// TODO: https://chatgpt.com/c/68da80e7-5b58-8333-b7f7-d518cb6ad500

[[ stitchable ]]
half4 parameterizedNoise(float2 position, half4 color, float intensity, float frequency, float opacity) {
  float value = fract(cos(dot(position * frequency, float2(12.9898, 78.233))) * 43758.5453);

  float r = color.r * mix(1.0, value, intensity);
  float g = color.g * mix(1.0, value, intensity);
  float b = color.b * mix(1.0, value, intensity);

  return half4(r, g, b, opacity);
}
