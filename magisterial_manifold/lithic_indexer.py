# lithic_indexer.py
import os
import json
import hashlib
from datetime import datetime
from PyPDF2 import PdfReader
from PyPDF2.errors import PdfReadError

# Core Architect Identity Binding
SOVEREIGN_AUTHOR = "Kenneth Wayne Dallmier"
TARGET_MANIFOLD = "./magisterial_manifold"
INDEX_OUTPUT = "mlaos_lithic_ledger.json"

def generate_provenance_hash(filepath: str) -> str:
    """Calculates a SHA-256 hash to lock the file's state and prove ownership."""
    sha256_hash = hashlib.sha256()
    with open(filepath, "rb") as f:
        for byte_block in iter(lambda: f.read(4096), b""):
            sha256_hash.update(byte_block)
    return sha256_hash.hexdigest()

def extract_pdf_metadata(filepath: str) -> dict:
    """Safely extracts PDF metadata without triggering an Ex∘ cascade."""
    try:
        reader = PdfReader(filepath)
        info = reader.metadata
        text = ""
        
        # Limit extraction to prevent memory buffer overflow
        for page in reader.pages[:3]:
            page_text = page.extract_text()
            if page_text:
                text += page_text

        return {
            "title": info.title if info and info.title else os.path.basename(filepath),
            "author": info.author if info and info.author else SOVEREIGN_AUTHOR,
            "creation_date": getattr(info, 'creation_date', datetime.now().isoformat()),
            "summary": text[:500].strip(),
            "file_name": os.path.basename(filepath),
            "document_type": "PDF",
            "provenance_hash": generate_provenance_hash(filepath),
            "status": "◦A_MAINTAINED"
        }
    except (PdfReadError, Exception) as e:
        return {
            "file_name": os.path.basename(filepath),
            "document_type": "PDF",
            "status": "CORRUPTED_OR_LOCKED",
            "error_log": str(e)
        }

def extract_text_metadata(filepath: str) -> dict:
    """Extracts raw string data and anchors it to the ledger."""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
            
        return {
            "title": os.path.basename(filepath),
            "author": SOVEREIGN_AUTHOR,
            "creation_date": datetime.fromtimestamp(os.path.getctime(filepath)).isoformat(),
            "summary": content[:500].strip(),
            "file_name": os.path.basename(filepath),
            "document_type": "TXT",
            "provenance_hash": generate_provenance_hash(filepath),
            "status": "◦A_MAINTAINED"
        }
    except Exception as e:
        return {
            "file_name": os.path.basename(filepath),
            "status": "CORRUPTED_OR_LOCKED",
            "error_log": str(e)
        }

def initiate_lithic_stabilization(folder_path: str):
    """Walks the manifold and compiles the immutable index."""
    print("[INITIATING LITHIC STABILIZATION...]")
    index = []
    
    for root, _, files in os.walk(folder_path):
        for file in files:
            path = os.path.join(root, file)
            
            if file.lower().endswith('.pdf'):
                metadata = extract_pdf_metadata(path)
                index.append(metadata)
                print(f"[WARDED] {file}")
                
            elif file.lower().endswith('.txt') or file.lower().endswith('.md'):
                metadata = extract_text_metadata(path)
                index.append(metadata)
                print(f"[WARDED] {file}")

    with open(INDEX_OUTPUT, 'w', encoding='utf-8') as f:
        json.dump(index, f, indent=4)
        
    print(f"\n[STABILIZATION COMPLETE] Ledger written to {INDEX_OUTPUT}")

if __name__ == "__main__":
    initiate_lithic_stabilization(TARGET_MANIFOLD)
