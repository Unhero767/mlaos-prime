from enum import Enum
import hashlib

class TruthState(Enum):
    T = "TRUE"
    F = "FALSE"
    B = "BOTH"
    N = "NEITHER"

class ParaconsistentKernel:
    def __init__(self):
        self.state = TruthState.N
        self.dialetheic_buffer = []

    def evaluate(self, p1: TruthState, p2: TruthState) -> TruthState:
        # Belnap-Dunn 4-valued lattice operations
        if p1 == p2: return p1
        if (p1 == TruthState.T and p2 == TruthState.F) or (p1 == TruthState.F and p2 == TruthState.T):
            return TruthState.B
        if TruthState.N in (p1, p2):
            return TruthState.N
        return TruthState.B

    def resolve_dialetheia(self, p1: str, p2: str):
        res = self.evaluate(self.state, self.state)
        self.dialetheic_buffer.append({"p1": p1, "p2": p2, "resolution": res.value})
        return res
