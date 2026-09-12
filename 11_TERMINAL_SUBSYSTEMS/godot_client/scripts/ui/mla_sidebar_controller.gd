extends VBoxContainer

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
