from textual.app import App, ComposeResult
from textual.widgets import Header, Footer, Static, Input
from textual.containers import Vertical
from textual.reactive import reactive
import sys, os

sys.path.append(os.path.expanduser("~/MLAOS-PRIME/04_LOGIC_AND_ENGINES/mlaos_core"))
from paraconsistent_kernel import ParaconsistentKernel, TruthState
from ash_archive import AshArchive

class MLAOS_TUI(App):
    CSS = """
    Screen { background: #07070a; color: #e0e0e8; }
    #hud { height: 1fr; border: solid #2a2a35; padding: 1; }
    #input-box { dock: bottom; height: 3; }
    """
    
    truth_state = reactive("NEITHER")
    node_count = reactive(0)

    def __init__(self):
        super().__init__()
        self.kernel = ParaconsistentKernel()
        self.archive = AshArchive(os.path.expanduser("~/MLAOS-PRIME/06_CANON_ARCHIVE/strata/ash_ledger.json"))
        self.node_count = len(self.archive.chain)

    def compose(self) -> ComposeResult:
        yield Header(show_clock=True)
        with Vertical(id="hud"):
            yield Static("MLAOS-PRIME // TERMINAL SUBSTRATE", classes="teal")
            yield Static(f"Prime Anchor: 37.7306° N, 88.0817° W (Olney, IL)")
            yield Static(f"Somatic Baseline: 1.5 Hz (90 BPM) | Carrier: 42.85 Hz")
            yield Static(f"Truth-State: [{self.truth_state}] | Nodes: {self.node_count}")
            yield Static("Tri-Key Sovereignty: Lead (Permineralized) | Cyan (Omnipresent) | Iron (Armed)")
        yield Input(placeholder="Enter command (invoke, transition, seal, verify)...", id="input-box")
        yield Footer()

    def on_input_submitted(self, event):
        cmd = event.value.strip().lower()
        hud = self.query_one("#hud")
        
        if cmd == "seal":
            h = self.archive.append_block({"action": "manual_seal", "state": self.truth_state})
            self.node_count = len(self.archive.chain)
            hud.mount(Static(f"[color=#00ff9d]SEALED:[/color] {h}"))
        elif cmd == "verify":
            valid, msg = self.archive.verify_chain()
            color = "#00ff9d" if valid else "#ff3d5a"
            hud.mount(Static(f"[color={color}]{msg}[/color]"))
        elif cmd.startswith("transition "):
            new_state = cmd.split(" ")[1].upper()
            if new_state in ["T", "F", "B", "N"]:
                self.truth_state = TruthState[new_state].value
                hud.mount(Static(f"State transitioned to [{self.truth_state}]"))
        else:
            hud.mount(Static(f"[color=#6b6b7b]Unknown command: {cmd}[/color]"))
            
        event.input.value = ""

if __name__ == "__main__":
    MLAOS_TUI().run()
