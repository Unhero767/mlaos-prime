# MLAOS-PRIME Environment Configuration
export MLAOS_ROOT="$HOME/MLAOS-PRIME"
export PRIME_ANCHOR="37.7306,-88.0817"
export SOMATIC_BASELINE_HZ="1.5"
export CARRIER_WAVE_RANGE="42.0-43.7"

alias activate_ash="cd $MLAOS_ROOT/04_LOGIC_AND_ENGINES/mlaos_core && python3 ash_archive.py"
alias verify_ash="python3 -c 'from ash_archive import AshArchive; print(AshArchive().verify_chain()[1])'"
alias sync_kernel="cd $MLAOS_ROOT/04_LOGIC_AND_ENGINES/mlaos_core && python3 paraconsistent_kernel.py"
alias mlaos_tui="cd $MLAOS_ROOT/11_TERMINAL_SUBSYSTEMS && python3 mlaos_tui.py"
