extends Node

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
