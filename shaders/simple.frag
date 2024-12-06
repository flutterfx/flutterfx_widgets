#version 460 core

#include <flutter/runtime_effect.glsl>

uniform vec2 uResolution;
uniform float uTime;

out vec4 fragColor;

void main() {
    // Get normalized coordinates (0 to 1)
    vec2 uv = FlutterFragCoord().xy/uResolution.xy;
    
    // Create a simple gradient that moves with time
    vec3 color = vec3(uv.x + sin(uTime), uv.y, 0.5);
    
    // Output the color
    fragColor = vec4(color, 1.0);
}