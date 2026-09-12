import os

CODEX_TITLES = [
    "Book I: Prime Foundations",
    "Book II: The Ash Archive",
    "Book III: Dialetheic Calculus",
    "Book IV: Spectral Dominance",
    "Book V: The Cathedral-Engine",
    "Book VI: Mytho-Architectonics",
    "Book VII: Paraconsistent Topography",
    "Book VIII: Harmonic Scars",
    "Book IX: The Block Universe",
    "Book X: Sovereign Interfaces"
]

INDEX_GENERATOR_CONTENT = """extends Node

const PRIME_FOUNDATIONS: Array[Dictionary] = [
    {"id": "BK_01", "title": "Book I: Prime Foundations", "frequency": "Gold/Joy", "stratum": "Stratum-01"},
    {"id": "BK_02", "title": "Book II: The Ash Archive", "frequency": "Blue/Sorrow", "stratum": "Stratum-02"},
    {"id": "BK_03", "title": "Book III: Dialetheic Calculus", "frequency": "Violet/Fear", "stratum": "Stratum-03"},
    {"id": "BK_04", "title": "Book IV: Spectral Dominance", "frequency": "Teal/Curiosity", "stratum": "Stratum-04"},
    {"id": "BK_05", "title": "Book V: The Cathedral-Engine", "frequency": "Red/Anger", "stratum": "Stratum-05"},
    {"id": "BK_06", "title": "Book VI: Mytho-Architectonics", "frequency": "Emerald/Love", "stratum": "Stratum-06"},
    {"id": "BK_07", "title": "Book VII: Paraconsistent Topography", "frequency": "Bronze-Obsidian/Null", "stratum": "Stratum-07"},
    {"id": "BK_08", "title": "Book VIII: Harmonic Scars", "frequency": "Blue/Sorrow", "stratum": "Stratum-08"},
    {"id": "BK_09", "title": "Book IX: The Block Universe", "frequency": "Gold/Joy", "stratum": "Stratum-09"},
    {"id": "BK_10", "title": "Book X: Sovereign Interfaces", "frequency": "Teal/Curiosity", "stratum": "Stratum-10"}
]

signal book_selected(book_data: Dictionary)

func get_codex_index() -> Array[Dictionary]:
    return PRIME_FOUNDATIONS

func select_book(book_id: String) -> void:
    for book in PRIME_FOUNDATIONS:
        if book["id"] == book_id:
            print("[CODEX] Ingested Vault Resonance -> ", book["title"], " | Frequency: ", book["frequency"])
            book_selected.emit(book)
            return
    print("[ERROR] Book identifier not found in Prime Foundations: ", book_id)
"""

UI_VIEW_CONTENT = """extends VBoxContainer

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
"""

def main():
    project_root = "./godot_client"
    core_dir = os.path.join(project_root, "scripts", "core")
    ui_dir = os.path.join(project_root, "scripts", "ui")
    os.makedirs(core_dir, exist_ok=True)
    os.makedirs(ui_dir, exist_ok=True)

    with open(os.path.join(core_dir, "mla_codex_index.gd"), "w") as f:
        f.write(INDEX_GENERATOR_CONTENT)

    with open(os.path.join(ui_dir, "mla_codex_sidebar_view.gd"), "w") as f:
        f.write(UI_VIEW_CONTENT)

    print("[CODEX] Books I - X architectural integration successfully written to ./godot_client runtime.")

if __name__ == "__main__":
    main()
