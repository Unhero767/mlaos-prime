// fBm Visual Resonance Shader (WebGL/GLSL)
precision highp float;
uniform float u_time;
uniform vec2 u_resolution;
uniform int u_truth_state; // 0=N, 1=T, 2=F, 3=B

vec2 hash(vec2 p) {
    p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
    return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(dot(hash(i + vec2(0.0, 0.0)), f - vec2(0.0, 0.0)),
                   dot(hash(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0)), u.x),
               mix(dot(hash(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0)),
                   dot(hash(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0)), u.x), u.y);
}

float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++) {
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;
    vec2 p = uv * 4.0;
    
    float f1 = fbm(p + u_time * 0.1);
    float f2 = fbm(p + vec2(f1) + u_time * 0.15);
    
    vec3 col;
    if (u_truth_state == 1) col = vec3(0.0, 1.0, 0.6); // Teal / Curiosity (T)
    else if (u_truth_state == 2) col = vec3(1.0, 0.24, 0.35); // Red / Anger (F)
    else if (u_truth_state == 3) col = vec3(1.0, 0.84, 0.0); // Gold / Joy (B)
    else col = vec3(0.29, 0.29, 0.35); // Obsidian / Void (N)
    
    col *= 0.5 + 0.5 * f2;
    gl_FragColor = vec4(col, 1.0);
}
