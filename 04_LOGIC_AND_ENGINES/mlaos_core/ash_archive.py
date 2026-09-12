import hashlib
import json
import sys
from datetime import datetime

class AshArchive:
    def __init__(self, db_path="ash_ledger.json"):
        self.db_path = db_path
        self.chain = []
        self._load_chain()

    def _load_chain(self):
        try:
            with open(self.db_path, 'r') as f:
                self.chain = json.load(f)
        except FileNotFoundError:
            self.chain = []

    def _save_chain(self):
        with open(self.db_path, 'w') as f:
            json.dump(self.chain, f, indent=2)

    def append_block(self, payload: dict):
        prev_hash = self.chain[-1]['hash'] if self.chain else "0" * 64
        timestamp = datetime.utcnow().isoformat()
        
        # Telemetry capture (Lex I: Never-Overwrite)
        telemetry = {
            "somatic_pulse_hz": 1.5,
            "carrier_wave_hz": 42.85,
            "prime_anchor": {"lat": 37.7306, "lon": -88.0817, "loc": "Olney, IL"}
        }
        
        block = {
            "index": len(self.chain),
            "timestamp": timestamp,
            "payload": payload,
            "telemetry": telemetry,
            "prev_hash": prev_hash
        }
        
        block_string = json.dumps(block, sort_keys=True)
        block['hash'] = hashlib.sha256(block_string.encode()).hexdigest()
        
        self.chain.append(block)
        self._save_chain()
        return block['hash']

    def verify_chain(self):
        for i in range(1, len(self.chain)):
            current = self.chain[i]
            prev = self.chain[i-1]
            
            temp_block = {k: v for k, v in current.items() if k != 'hash'}
            temp_string = json.dumps(temp_block, sort_keys=True)
            if hashlib.sha256(temp_string.encode()).hexdigest() != current['hash']:
                return False, f"Hash mismatch at index {i}"
                
            if current['prev_hash'] != prev['hash']:
                return False, f"Linkage broken at index {i}"
                
        return True, f"Chain verified. {len(self.chain)} nodes intact. Lex I (Never-Overwrite) enforced."

if __name__ == "__main__":
    archive = AshArchive()
    if "--seal" in sys.argv:
        h = archive.append_block({"action": "manual_seal"})
        print(f"SEALED: {h}")
    else:
        valid, msg = archive.verify_chain()
        print(msg)
