extends Node

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
