import os

SHADER_CONTENT = """shader_type canvas_item;

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
"""

CONTROLLER_CONTENT = """extends VBoxContainer

@export var hover_frequency_tag: String = "Teal/Curiosity"

func _ready() -> void:
    for node in get_tree().get_nodes_in_group("mla_sidebar_buttons"):
        if node is BaseButton:
            node.mouse_entered.connect(_on_button_hover.bind(node))
            node.pressed.connect(_on_button_pressed.bind(node))

func _on_button_hover(button: BaseButton) -> void:
    var tween = create_tween().set_parallel(true)
    tween.tween_property(button, "custom_minimum_size:x", 220.0, 0.2).from(200.0)

func _on_button_pressed(button: BaseButton) -> void:
    if button.has_meta("target_passage"):
        var passage_id = button.get_meta("target_passage")
        print("[ARCHIVE] Routing to structural stratum: ", passage_id)
"""

def main():
    project_root = "./godot_client"
    
    shader_dir = os.path.join(project_root, "shaders")
    script_dir = os.path.join(project_root, "scripts", "ui")
    os.makedirs(shader_dir, exist_ok=True)
    os.makedirs(script_dir, exist_ok=True)

    with open(os.path.join(shader_dir, "ash_archive_drift.gdshader"), "w") as f:
        f.write(SHADER_CONTENT)
    
    with open(os.path.join(script_dir, "mla_sidebar_controller.gd"), "w") as f:
        f.write(CONTROLLER_CONTENT)

    print("[ARCHIVE] Enhanced controller and shader successfully updated in ./godot_client runtime.")

if __name__ == "__main__":
    main()
