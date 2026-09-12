extends VBoxContainer

@onready var codex_backend = Node.new() # Or autoload reference

func _ready() -> void:
    # Dynamically populate Books I - X into the sidebar layout
    for child in get_children():
        if child is Button:
            child.queue_free()
            
    # Load script dynamically if not singleton
    var backend_script = load("res://scripts/core/mla_codex_index.gd")
    var index_instance = backend_script.new()
    
    for book in index_instance.get_codex_index():
        var btn = Button.new()
        btn.text = book["title"]
        btn.set_meta("book_id", book["id"])
        btn.set_meta("frequency", book["frequency"])
        btn.add_to_group("mla_sidebar_buttons")
        btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
        btn.custom_minimum_size = Vector2(0, 36)
        
        btn.pressed.connect(_on_codex_button_pressed.bind(btn, index_instance))
        add_child(btn)

func _on_codex_button_pressed(button: Button, backend) -> void:
    var b_id = button.get_meta("book_id")
    var freq = button.get_meta("frequency")
    print("[UI] Triggered Vault Gateway: ", b_id, " [Frequency: ", freq, "]")
    backend.select_book(b_id)
