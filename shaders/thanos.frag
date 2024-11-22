#version 460 core
precision highp float;

uniform float iTime;
uniform vec2 iResolution;
uniform sampler2D iImage;
uniform float dissolveScale;

// Simplex noise function
vec3 mod289(vec3 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec2 mod289(vec2 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec3 permute(vec3 x) { return mod289(((x*34.0)+1.0)*x); }

float snoise(vec2 v) {
    const vec4 C = vec4(0.211324865405187,
                       0.366025403784439,
                      -0.577350269189626,
                       0.024390243902439);
    vec2 i  = floor(v + dot(v, C.yy));
    vec2 x0 = v -   i + dot(i, C.xx);
    vec2 i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
    vec4 x12 = x0.xyxy + C.xxzz;
    x12.xy -= i1;
    i = mod289(i);
    vec3 p = permute(permute(i.y + vec3(0.0, i1.y, 1.0)) + i.x + vec3(0.0, i1.x, 1.0));
    vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
    m = m*m;
    m = m*m;
    vec3 x = 2.0 * fract(p * C.www) - 1.0;
    vec3 h = abs(x) - 0.5;
    vec3 ox = floor(x + 0.5);
    vec3 a0 = x - ox;
    m *= 1.79284291400159 - 0.85373472095314 * (a0*a0 + h*h);
    vec3 g;
    g.x  = a0.x  * x0.x  + h.x  * x0.y;
    g.yz = a0.yz * x12.xz + h.yz * x12.yw;
    return 130.0 * dot(m, g);
}

void main() {
    vec2 uv = gl_FragCoord.xy / iResolution.xy;
    vec4 color = texture2D(iImage, uv);
    
    // Create multi-layered noise
    float bigNoise = snoise(uv * 4.0 + iTime * 0.5) * 0.5;
    float fineNoise = snoise(uv * 40.0 + iTime * 2.0) * 0.5;
    float combinedNoise = bigNoise + fineNoise;
    
    // Create displacement effect
    vec2 displacement = vec2(combinedNoise) * dissolveScale;
    vec4 displacedColor = texture2D(iImage, uv + displacement);
    
    // Create dissolve threshold
    float dissolveThreshold = snoise(uv * 3.0 + iTime) * dissolveScale;
    float alpha = smoothstep(dissolveThreshold, dissolveThreshold + 0.1, combinedNoise);
    
    // Output final color with displacement and dissolve
    gl_FragColor = vec4(displacedColor.rgb, displacedColor.a * alpha);
}