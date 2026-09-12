import os

PROJECT_ROOT = "./godot_client"

FILES = {
    "scripts/core/ash_archive.gd": """extends Node

var archive_entries: Array = []

func append_entry(payload: Dictionary) -> void:
    var entry := {
        "entry_id": archive_entries.size(),
        "timestamp": Time.get_unix_time_from_system(),
        "payload": payload
    }
    archive_entries.append(entry)
    print("AshArchive: Recorded entry #%d" % entry["entry_id"])

func save_archive() -> void:
    var file = FileAccess.open("user://ash_archive.save", FileAccess.WRITE)
    if file:
        file.store_string(JSON.stringify(archive_entries))
        print("AshArchive: State persisted to disk.")
""",
    
    "scenes/CatPlayer.tscn": """[gd_scene load_steps=3 format=3]

[ext_resource type="Script" path="res://scripts/entities/cat_player.gd" id="1_cat"]

[sub_resource type="CapsuleShape2D" id="CapsuleShape2D_1"]
radius = 6.0
height = 16.0

[node name="CatPlayer" type="CharacterBody2D"]
y_sort_enabled = true
script = ExtResource("1_cat")

[node name="CollisionShape2D" type="CollisionShape2D" parent="."]
rotation = 1.5708
shape = SubResource("CapsuleShape2D_1")

[node name="Sprite2D" type="Sprite2D" parent="."]
offset = Vector2(0, -10)
""",

    "scripts/entities/cat_player.gd": """extends CharacterBody2D

@export var speed: float = 120.0
@onready var sprite: Sprite2D = $Sprite2D

func _physics_process(_delta: float) -> void:
    var direction := Vector2.ZERO
    direction.x = Input.get_axis("ui_left", "ui_right")
    direction.y = Input.get_axis("ui_up", "ui_down")
    
    if direction != Vector2.ZERO:
        direction = direction.normalized()
        velocity = direction * speed
        if direction.x != 0:
            sprite.flip_h = direction.x < 0
    else:
        velocity = velocity.move_toward(Vector2.ZERO, speed)
        
    move_and_slide()
"""
}

def main():
    for rel_path, content in FILES.items():
        full_path = os.path.join(PROJECT_ROOT, rel_path)
        os.makedirs(os.path.dirname(full_path), exist_ok=True)
        with open(full_path, "w") as f:
            f.write(content)
        print(f"[SCAFFOLD] Injected -> {full_path}")

if __name__ == "__main__":
    main()
