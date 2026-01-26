#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 invert(float2 pos, half4 color) {
  return half4((1 - color.xyz), 1);
}
