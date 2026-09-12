shader_type canvas_item;

uniform vec4 base_color : source_color = vec4(0.05, 0.05, 0.07, 0.85);
uniform vec4 line_color : source_color = vec4(0.2, 0.6, 0.8, 0.15);
uniform float frequency = 400.0;
uniform float speed = 2.0;

void fragment() {
    float wave = sin(UV.y * frequency + TIME * speed);
    vec4 col = base_color + line_color * wave;
    float vignette = UV.x * UV.y * (1.0 - UV.x) * (1.0 - UV.y) * 16.0;
    vignette = clamp(pow(vignette, 0.25), 0.0, 1.0);
    COLOR = vec4(col.rgb * vignette, col.a);
}
