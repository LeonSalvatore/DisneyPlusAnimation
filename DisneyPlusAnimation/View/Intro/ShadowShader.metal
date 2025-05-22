//
//  ShadowShader.metal
//  ClockAnimation
//
//  Created by Leon Salvatore on 22.05.2025.
//

#include <metal_stdlib>
using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float2 uv;
    float3 worldPos;
};

struct Light {
    float3 position;
    float radius;
    float3 color;
};

#include <metal_stdlib>
using namespace metal;

// Vertex shader must match exactly what you call in Swift
vertex float4 vertex_main(
    const device packed_float2* vertex_array [[ buffer(0) ]],
    unsigned int vid [[ vertex_id ]]
) {
    return float4(vertex_array[vid], 0.0, 1.0);
}

// Fragment shader must match exactly
fragment float4 fragment_main() {
    return float4(1.0, 0.0, 0.0, 1.0); // Red color for testing
}
