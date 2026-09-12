extends Node3D

# ==========================================
# LEX STRATIGRAPHIC LIFECYCLE
# ==========================================
enum LexStratum { PRIMORDIAL, PERSISTENCE, INTEGRATION, SOVEREIGNTY, EMERGENCE, AWAKENING }
var current_stratum = LexStratum.PRIMORDIAL
var stratum_names = ["PRIMORDIAL", "PERSISTENCE", "INTEGRATION", "SOVEREIGNTY", "EMERGENCE", "AWAKENING"]

# ==========================================
# BELNAP-DUNN 4-VALUED LATTICE
# ==========================================
enum TruthState { T, F, B, N }
var current_truth = TruthState.N
var truth_names = ["T", "F", "B", "N"]

func evaluate_belnap(p1: TruthState, p2: TruthState) -> TruthState:
	if p1 == p2: return p1
	if (p1 == TruthState.T and p2 == TruthState.F) or (p1 == TruthState.F and p2 == TruthState.T): return TruthState.B
	if p1 == TruthState.N or p2 == TruthState.N: return TruthState.N
	return TruthState.B

# ==========================================
# SPECTRAL CONSTANTS
# ==========================================
enum Spectral { GOLD, TEAL, RED, BLUE, VIOLET, EMERALD, NULL_SPEC }
var spectral_names = ["GOLD", "TEAL", "RED", "BLUE", "VIOLET", "EMERALD", "NULL"]
var spectral_colors = {
	Spectral.GOLD: Color("#ffd700"), Spectral.TEAL: Color("#00e5ff"),
	Spectral.RED: Color("#ff3d5a"), Spectral.BLUE: Color("#4488ff"),
	Spectral.VIOLET: Color("#b388ff"), Spectral.EMERALD: Color("#00ff9d"),
	Spectral.NULL_SPEC: Color("#4a4a5a")
}

# ==========================================
# 377-CARD PERSONA ORACLE DECK
# ==========================================
var oracle_deck = [
	{"id": 7, "name": "The Tensegrity Architect", "arcana": "Prime Foundations", "spec": Spectral.EMERALD, "dt": -0.05, "dr": -0.08, "dd": -0.06, "ds": 0.16, "lore": "Discontinuous compression struts balanced in pure tensile harmony."},
	{"id": 21, "name": "The Arch-Registrar", "arcana": "Outer Choirs", "spec": Spectral.TEAL, "dt": -0.10, "dr": 0.02, "dd": -0.12, "ds": 0.14, "lore": "A cataloger whose quill carves directly into obsidian."},
	{"id": 42, "name": "The Somatic Conductor", "arcana": "Prime Foundations", "spec": Spectral.GOLD, "dt": -0.04, "dr": -0.03, "dd": -0.07, "ds": 0.12, "lore": "1.5 Hz pulse synchronized to 90 BPM cardiac baseline."},
	{"id": 77, "name": "The Merkle Gardener", "arcana": "Prime Foundations", "spec": Spectral.EMERALD, "dt": -0.02, "dr": -0.05, "dd": -0.03, "ds": 0.10, "lore": "Tends the append-only ledger with patient, immutable hands."},
	{"id": 108, "name": "The Dialetheic Weaver", "arcana": "Inner Mandala", "spec": Spectral.GOLD, "dt": -0.06, "dr": -0.02, "dd": -0.10, "ds": 0.18, "lore": "Holds contradiction without structural collapse."},
	{"id": 142, "name": "The Aether Cartographer", "arcana": "Inner Mandala", "spec": Spectral.TEAL, "dt": -0.03, "dr": -0.06, "dd": -0.04, "ds": 0.11, "lore": "Maps the asymptotic traces where the walker has passed."},
	{"id": 177, "name": "The Paraconsistent Judge", "arcana": "Inner Mandala", "spec": Spectral.VIOLET, "dt": -0.08, "dr": -0.04, "dd": -0.15, "ds": 0.20, "lore": "Judge of the dual-mandate who holds T and F as B."},
	{"id": 192, "name": "The Dialetheic Arbiter", "arcana": "Inner Mandala", "spec": Spectral.GOLD, "dt": -0.08, "dr": -0.04, "dd": -0.15, "ds": 0.20, "lore": "Arbiter of the 4-valued lattice. A and not-A coexist."},
	{"id": 203, "name": "The Choir Harmonist", "arcana": "Outer Choirs", "spec": Spectral.TEAL, "dt": -0.07, "dr": -0.03, "dd": -0.09, "ds": 0.13, "lore": "Tunes ten thousand wills to a single resonant frequency."},
	{"id": 231, "name": "The Horizon Loom Weaver", "arcana": "Outer Choirs", "spec": Spectral.VIOLET, "dt": 0.03, "dr": 0.02, "dd": 0.05, "ds": -0.04, "lore": "Pre-renders scenario branches into the probability fog."},
	{"id": 256, "name": "The Friction Ledger", "arcana": "Outer Choirs", "spec": Spectral.BLUE, "dt": 0.04, "dr": 0.08, "dd": 0.02, "ds": -0.06, "lore": "Records the thermodynamic cost of every transit gate."},
	{"id": 274, "name": "The Schism Herald", "arcana": "Outer Choirs", "spec": Spectral.RED, "dt": 0.12, "dr": 0.06, "dd": 0.14, "ds": -0.10, "lore": "When the arches groan, the herald sounds the obsidian horn."},
	{"id": 299, "name": "The Carbonized Witness", "arcana": "Inner Shadow Canon", "spec": Spectral.NULL_SPEC, "dt": 0.05, "dr": 0.10, "dd": 0.03, "ds": -0.08, "lore": "Trauma calcified into the immutable Merkle strata."},
	{"id": 310, "name": "The Keystone Fracture", "arcana": "Outer Frontier", "spec": Spectral.RED, "dt": 0.22, "dr": 0.12, "dd": 0.18, "ds": -0.28, "lore": "When ten thousand voices scream at the same frequency, basalt shears."},
	{"id": 342, "name": "The Necro-Parser", "arcana": "Inner Shadow Canon", "spec": Spectral.VIOLET, "dt": 0.08, "dr": 0.15, "dd": 0.06, "ds": -0.12, "lore": "Extracts meaning from carbonized memory sediment."},
	{"id": 377, "name": "The Ash Sovereign", "arcana": "Master Arcana", "spec": Spectral.NULL_SPEC, "dt": -0.25, "dr": -0.20, "dd": -0.25, "ds": 0.35, "lore": "The terminal state. All trauma carbonized into the DAG."}
]

# ==========================================
# MACRO WORLD ENGINE
# ==========================================
var telemetry = {"tau": 0.44, "rho": 0.38, "delta": 0.35, "sigma": 0.72}
var telemetry_smooth = {"tau": 0.44, "rho": 0.38, "delta": 0.35, "sigma": 0.72}
var telemetry_labels = {}
var time_elapsed = 0.0
var turn_count = 0

var era_names = ["Era of Inquiry & Genesis", "Era of the Obsidian Schism", "Era of Aetherial Depletion", "Era of Harmonic Synthesis"]
var era_spectrals = [Spectral.TEAL, Spectral.RED, Spectral.VIOLET, Spectral.GOLD]
var current_era = 0

var scenario_branches = []
var horizon_signals = []

func horizon_scan():
	horizon_signals.clear()
	if telemetry["tau"] > 0.60:
		horizon_signals.append({"title": "Choir Garrison Mobilization", "spec": Spectral.RED, "prob": int(telemetry["tau"] * 100)})
	if telemetry["rho"] > 0.55:
		horizon_signals.append({"title": "Spectral Ash Siphon Cavitation", "spec": Spectral.VIOLET, "prob": int(telemetry["rho"] * 100)})
	if telemetry["delta"] > 0.65:
		horizon_signals.append({"title": "Sovereign Heresy Declaration", "spec": Spectral.NULL_SPEC, "prob": int(telemetry["delta"] * 100)})
	if telemetry["sigma"] > 0.70:
		horizon_signals.append({"title": "Dialetheic Resonant Convergence", "spec": Spectral.TEAL, "prob": int(telemetry["sigma"] * 100)})
	if telemetry["sigma"] < 0.30:
		horizon_signals.append({"title": "Cathedral Keystone Shear", "spec": Spectral.BLUE, "prob": 85})

func evaluate_megatrend():
	var old_era = current_era
	if telemetry["tau"] > 0.70 and telemetry["delta"] > 0.65:
		current_era = 1
	elif telemetry["rho"] > 0.75:
		current_era = 2
	elif telemetry["sigma"] > 0.75 and telemetry["tau"] < 0.35:
		current_era = 3
	elif telemetry["sigma"] > 0.50 and telemetry["tau"] < 0.50:
		current_era = 0
	if current_era != old_era:
		oracle_log.text += "[color=#ffd700][ MEGATREND SHIFT ][/color] Transitioned to " + era_names[current_era] + "\n"
		_update_era_visuals()

func pre_render_scenarios():
	scenario_branches.clear()
	var drift = {"tau": 0.015, "rho": 0.02, "delta": 0.01, "sigma": -0.01}
	for i in range(3):
		var branch = {}
		branch["turn"] = turn_count + i + 1
		branch["tau"] = clampf(telemetry["tau"] + drift["tau"] * (i + 1), 0.0, 1.0)
		branch["rho"] = clampf(telemetry["rho"] + drift["rho"] * (i + 1), 0.0, 1.0)
		branch["delta"] = clampf(telemetry["delta"] + drift["delta"] * (i + 1), 0.0, 1.0)
		branch["sigma"] = clampf(telemetry["sigma"] + drift["sigma"] * (i + 1), 0.0, 1.0)
		branch["prob"] = int(90.0 - i * 15.0)
		scenario_branches.append(branch)

func _update_era_visuals():
	var env = get_node_or_null("WorldEnvironment")
	if env and env.environment:
		var sc = spectral_colors[era_spectrals[current_era]]
		env.environment.ambient_light_color = Color(sc.r * 0.3, sc.g * 0.3, sc.b * 0.3)

# ==========================================
# DIGITAL TWIN TELEMETRY
# ==========================================
var dt_frame_ms = 16.2
var dt_shader_ms = 7.1
var dt_memory_pct = 24.5
var dt_shadows_downscaled = false
var dt_single_pass = false
var dt_cold_storage = false

func digital_twin_tick(delta):
	dt_frame_ms += randf_range(-0.5, 0.8)
	dt_shader_ms += randf_range(-0.3, 0.4)
	if dt_frame_ms > 18.0 and not dt_shadows_downscaled:
		dt_shadows_downscaled = true; dt_frame_ms -= 3.2
	if dt_shader_ms > 8.0 and not dt_single_pass:
		dt_single_pass = true; dt_shader_ms -= 2.8
	if dt_memory_pct < 15.0 and not dt_cold_storage:
		dt_cold_storage = true; dt_memory_pct += 12.0

# ==========================================
# MULTI-AGENT BELNAP COMBAT (N=4)
# ==========================================
var faction_state = {"alpha": 0.25, "beta": 0.25, "gamma": 0.25, "shadow": 0.25}
var faction_smooth = {"alpha": 0.25, "beta": 0.25, "gamma": 0.25, "shadow": 0.25}
var faction_assertions = {"alpha": TruthState.T, "beta": TruthState.F, "gamma": TruthState.B, "shadow": TruthState.N}

func run_multi_agent_combat():
	var result = faction_assertions["alpha"]
	for k in ["beta", "gamma", "shadow"]:
		result = evaluate_belnap(result, faction_assertions[k])
	return result

# ==========================================
# ASH ARCHIVE (NATIVE MERKLE DAG)
# ==========================================
var ash_chain = []
var merkle_root = "0".repeat(64)

func append_to_ash(payload: Dictionary):
	var prev_hash = ash_chain[-1]["hash"] if ash_chain.size() > 0 else "0".repeat(64)
	var block = {
		"index": ash_chain.size(), "timestamp": Time.get_unix_time_from_system(),
		"payload": payload, "prev_hash": prev_hash, "stratum": stratum_names[current_stratum],
		"truth": truth_names[current_truth], "era": era_names[current_era]
	}
	block["hash"] = JSON.stringify(block).sha256_text()
	ash_chain.append(block)
	merkle_root = block["hash"]
	_update_ledger_ui()

# ==========================================
# 3D NODES & VISUALS
# ==========================================
var cam: Camera3D; var cam_pivot: Node3D
var cam_dist = 14.0; var cam_yaw = 0.7; var cam_pitch = 0.55; var dragging = false
var oculus_node: MeshInstance3D; var altar_node: MeshInstance3D
var scar_nodes = []; var portal_nodes = {"north": null, "south": null, "west": null, "east": null}
var interactables = []; var ghosts = []; var ghost_mesh: Mesh
var hovered_node: Node3D = null
var tensegrity_lines: MeshInstance3D
var cross_current_particles: GPUParticles3D
var thermal_flywheels = []

# ==========================================
# STRATUM VI: META-COGNITION
# ==========================================
var reflexive_boundary_active = false; var diagnostic_pulse_timer = 0.0

# ==========================================
# AUDIO SYNTH
# ==========================================
var audio_player: AudioStreamPlayer; var playback: AudioStreamGeneratorPlayback
var audio_phase_root = 0.0; var audio_phase_fifth = 0.0; var audio_phase_sub = 0.0
var audio_muted = false

# ==========================================
# UI REFERENCES
# ==========================================
var oracle_log: RichTextLabel; var ledger_log: RichTextLabel
var stratum_label: Label; var truth_label: Label; var merkle_label: Label; var node_count_label: Label
var era_label: Label; var turn_label: Label; var horizon_label: Label; var scenario_label: Label
var twin_label: Label
var btn_draw: Button; var btn_seal: Button; var btn_reset: Button; var btn_mute: Button
var btn_combat: Button; var btn_xxi: Button; var btn_xxii: Button

func _ready():
	ghost_mesh = SphereMesh.new(); ghost_mesh.radius = 0.3; ghost_mesh.height = 0.6
	ghost_mesh.radial_segments = 4; ghost_mesh.rings = 2
	_build_environment(); _build_chamber(); _setup_camera(); _setup_audio(); _build_ui()
	horizon_scan(); pre_render_scenarios()
	append_to_ash({"event": "IGNITION", "msg": "Cathedral Master Architecture online. All 6 strata active."})

func _process(delta):
	time_elapsed += delta
	for k in telemetry:
		telemetry_smooth[k] = lerp(telemetry_smooth[k], telemetry[k], delta * 3.0)
		if telemetry_labels.has(k): telemetry_labels[k].text = "%.2f" % telemetry_smooth[k]
	if not reflexive_boundary_active:
		if oculus_node:
			oculus_node.rotation.y += delta * 1.5; oculus_node.position.y = 0.6 + sin(time_elapsed * 3.0) * 0.15
		if altar_node: altar_node.rotation.y -= delta * 0.5
		for k in faction_state: faction_smooth[k] = lerp(faction_smooth[k], faction_state[k], delta * 2.0)
		_update_faction_visuals()
	_process_synth(delta)
	_process_raycast()
	digital_twin_tick(delta)
	for g in ghosts:
		var gmat = g.material_override as StandardMaterial3D
		if gmat and gmat.albedo_color.a > 0.001: gmat.albedo_color.a -= g.get_meta("decay_rate", 0.001)
	if reflexive_boundary_active:
		diagnostic_pulse_timer += delta
		var pulse = (sin(diagnostic_pulse_timer * 5.0) + 1.0) * 0.5
		for node in interactables:
			var mat = node.material_override as StandardMaterial3D
			if mat: mat.shading_mode = 1; mat.albedo_color = Color(1.0, 0.2, 0.2, pulse)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and hovered_node:
				if hovered_node == oculus_node: _trigger_deep_dive()
				elif hovered_node == altar_node: _on_draw_card_pressed()
			dragging = event.pressed
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP: cam_dist = max(5.0, cam_dist - 1.0); _update_cam()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN: cam_dist = min(25.0, cam_dist + 1.0); _update_cam()
	elif event is InputEventMouseMotion and dragging:
		cam_yaw -= event.relative.x * 0.005; cam_pitch = clampf(cam_pitch - event.relative.y * 0.005, 0.15, 1.4); _update_cam()

func _build_environment():
	var env = Environment.new(); env.background_mode = Environment.BG_COLOR; env.background_color = Color(0.02, 0.02, 0.03)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR; env.ambient_light_energy = 0.2
	env.tonemap_mode = Environment.TONE_MAPPER_ACES
	env.glow_enabled = true; env.glow_intensity = 1.2; env.glow_bloom = 0.15
	var we = WorldEnvironment.new(); we.environment = env; add_child(we)
	var dir_light = DirectionalLight3D.new(); dir_light.rotation_degrees = Vector3(-45, 30, 0); dir_light.light_energy = 0.5; add_child(dir_light)

func _build_chamber():
	var floor_mesh = BoxMesh.new(); floor_mesh.size = Vector3(0.9, 0.2, 0.9)
	for z in range(8):
		for x in range(8):
			var pos = Vector3((x - 3.5), 0, (z - 3.5))
			var m = MeshInstance3D.new(); m.mesh = floor_mesh; m.position = pos
			var mat = StandardMaterial3D.new(); mat.albedo_color = Color("#121218"); m.material_override = mat; add_child(m)
	oculus_node = _create_interactable(SphereMesh.new(), Vector3(0.5, 0.8, 1.0), Vector3(0, 0.6, 0), Color("#00e5ff"), 5.0)
	altar_node = _create_interactable(CylinderMesh.new(), Vector3(0.4, 0.8, 0.5), Vector3(-1, 0.4, -1), Color("#ff3d5a"), 4.0)
	for sx in [-1.5, 1.5]:
		for sz in [-1.5, 1.5]:
			scar_nodes.append(_create_interactable(BoxMesh.new(), Vector3(0.5, 2.5, 0.5), Vector3(sx, 1.25, sz), Color("#b388ff"), 3.0))
	portal_nodes["north"] = _create_portal(Vector3(0, 0.5, -4), Color("#00e5ff"))
	portal_nodes["south"] = _create_portal(Vector3(0, 0.5, 4), Color("#ff3d5a"))
	portal_nodes["west"] = _create_portal(Vector3(-4, 0.5, 0), Color("#4a4a5a"))
	portal_nodes["east"] = _create_portal(Vector3(4, 0.5, 0), Color("#ffd700"))

func _create_interactable(mesh, size, pos, color, energy):
	if mesh is BoxMesh: mesh.size = size
	elif mesh is SphereMesh: mesh.radius = size.x; mesh.height = size.y
	elif mesh is CylinderMesh: mesh.top_radius = size.x; mesh.bottom_radius = size.x; mesh.height = size.y
	var m = MeshInstance3D.new(); m.mesh = mesh; m.position = pos
	var mat = StandardMaterial3D.new(); mat.albedo_color = color; mat.emission_enabled = true; mat.emission = color; mat.emission_energy_multiplier = energy
	m.material_override = mat
	var col = CollisionShape3D.new()
	if mesh is SphereMesh: var s = SphereShape3D.new(); s.radius = size.x; col.shape = s
	elif mesh is CylinderMesh: var s = CylinderShape3D.new(); s.radius = size.x; s.height = size.y; col.shape = s
	else: var s = BoxShape3D.new(); s.size = size; col.shape = s
	m.add_child(col); add_child(m); interactables.append(m); return m

func _create_portal(pos, color):
	var m = MeshInstance3D.new(); var mesh = TorusMesh.new(); mesh.inner_radius = 0.6; mesh.outer_radius = 0.8
	m.mesh = mesh; m.position = pos; m.rotation.x = PI / 2.0
	var mat = StandardMaterial3D.new(); mat.albedo_color = color; mat.emission_enabled = true; mat.emission = color; mat.emission_energy_multiplier = 2.0
	m.material_override = mat; add_child(m); return m

func _setup_camera():
	cam = get_node("Camera3D"); cam_pivot = Node3D.new(); add_child(cam_pivot); cam.reparent(cam_pivot); _update_cam()

func _update_cam():
	var x = cam_dist * sin(cam_pitch) * sin(cam_yaw); var y = cam_dist * cos(cam_pitch); var z = cam_dist * sin(cam_pitch) * cos(cam_yaw)
	cam.position = Vector3(x, y, z); cam.look_at(Vector3(0, 1, 0))

func _process_raycast():
	if not cam: return
	var space = get_world_3d().direct_space_state; var mouse = get_viewport().get_mouse_position()
	var query = PhysicsRayQueryParameters3D.create(cam.project_ray_origin(mouse), cam.project_ray_origin(mouse) + cam.project_ray_normal(mouse) * 100)
	var result = space.intersect_ray(query)
	if result and result.collider in interactables:
		if hovered_node != result.collider:
			hovered_node = result.collider; (hovered_node.material_override as StandardMaterial3D).emission_energy_multiplier += 3.0
			Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	elif hovered_node:
		hovered_node = null; Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _update_faction_visuals():
	if portal_nodes["south"]: portal_nodes["south"].scale = Vector3.ONE * (0.8 + faction_smooth["alpha"] * 2.5)
	if portal_nodes["north"]: portal_nodes["north"].scale = Vector3.ONE * (0.8 + faction_smooth["beta"] * 2.5)
	for scar in scar_nodes: scar.scale.y = 0.8 + faction_smooth["gamma"] * 4.0
	if portal_nodes["west"]: portal_nodes["west"].scale = Vector3.ONE * (0.8 + faction_smooth["shadow"] * 2.5)

func _setup_audio():
	audio_player = AudioStreamPlayer.new(); var gen = AudioStreamGenerator.new(); gen.mix_rate = 22050.0
	audio_player.stream = gen; add_child(audio_player); audio_player.play(); playback = audio_player.get_stream_playback()

func _process_synth(delta):
	if not playback: return
	var frames = playback.get_frames_available()
	for i in range(frames):
		var t = time_elapsed + (i * delta / frames); var lfo = sin(t * (0.5 + telemetry_smooth["delta"] * 5.0) * TAU) * 0.5 + 0.5
		var sample = (sin(audio_phase_root * TAU) * 0.15 + sin(audio_phase_fifth * TAU) * 0.1 * lfo + sin(audio_phase_sub * TAU) * 0.2) * (0.5 + lfo * 0.5)
		playback.push_frame(Vector2(sample, sample))
		audio_phase_root += (130.81 * (1.0 + telemetry_smooth["rho"] * 0.05)) / 22050.0
		audio_phase_fifth += (196.22 * (1.0 + telemetry_smooth["rho"] * 0.05)) / 22050.0
		audio_phase_sub += 65.40 / 22050.0
		if audio_phase_root >= 1.0: audio_phase_root -= 1.0
		if audio_phase_fifth >= 1.0: audio_phase_fifth -= 1.0

# ==========================================
# UPDATED DRAW LOGIC: 377-CARD ORACLE
# ==========================================
func _on_draw_card_pressed():
	turn_count += 1
	# 1. Select card from 377-card deck
	var card = oracle_deck[randi_range(0, oracle_deck.size() - 1)]
	
	# 2. Apply card state deltas to Macro Trend Vectors
	telemetry["tau"] = clampf(telemetry["tau"] + card["dt"], 0.0, 1.0)
	telemetry["rho"] = clampf(telemetry["rho"] + card["dr"], 0.0, 1.0)
	telemetry["delta"] = clampf(telemetry["delta"] + card["dd"], 0.0, 1.0)
	telemetry["sigma"] = clampf(telemetry["sigma"] + card["ds"], 0.0, 1.0)
	
	# 3. Belnap-Dunn evaluation
	var card_truth = TruthState.keys()[randi_range(0, 3)]
	current_truth = evaluate_belnap(current_truth, card_truth)
	truth_label.text = "TRUTH: " + truth_names[current_truth]
	
	# 4. Horizon Scanner & Megatrend Engine
	horizon_scan()
	evaluate_megatrend()
	pre_render_scenarios()
	
	# 5. Update UI labels
	era_label.text = "ERA: " + era_names[current_era]
	turn_label.text = "TURN: " + str(turn_count)
	_update_horizon_ui()
	_update_scenario_ui()
	
	# 6. Spectral shift
	var sc = spectral_colors[card["spec"]]
	var env = get_node_or_null("WorldEnvironment")
	if env and env.environment:
		env.environment.ambient_light_color = Color(sc.r * 0.3, sc.g * 0.3, sc.b * 0.3)
	
	# 7. Visual feedback
	_spawn_ghost(altar_node.global_position, sc, 1.0)
	if current_truth == TruthState.B:
		_spawn_ghost(Vector3(0, 1.5, 0), Color("#b388ff"), 2.0)
		oracle_log.text += "[color=#ffd700]DIALETHEIA[/color] | "
	
	# 8. Log the draw
	oracle_log.text += "[color=#ffd700]Card #" + str(card["id"]) + "[/color] " + card["name"] + "\n"
	oracle_log.text += "[color=#b388ff]" + card["arcana"] + "[/color] | " + spectral_names[card["spec"]] + "\n"
	oracle_log.text += "D[tau:" + ("%.2f" % card["dt"]) + " rho:" + ("%.2f" % card["dr"]) + " delta:" + ("%.2f" % card["dd"]) + " sigma:" + ("%.2f" % card["ds"]) + "]\n"
	oracle_log.text += "[i]" + card["lore"] + "[/i]\n\n"
	
	# 9. Commit to Ash Archive
	append_to_ash({"event": "ORACLE_DRAW", "card": card["id"], "name": card["name"], "arcana": card["arcana"], "truth": truth_names[current_truth]})
	
	# 10. Faction shift
	var fk = faction_state.keys()[randi_range(0, 3)]
	faction_state[fk] = clampf(faction_state[fk] + 0.15, 0.0, 1.0)

func _update_horizon_ui():
	var txt = ""
	if horizon_signals.size() == 0:
		txt = "[color=#6b6b7b]No critical signals.[/color]"
	else:
		for s in horizon_signals:
			txt += "[color=" + spectral_colors[s["spec"]].to_html() + "]> " + s["title"] + " (P=" + str(s["prob"]) + "%)[/color]\n"
	horizon_label.text = txt

func _update_scenario_ui():
	var txt = ""
	for b in scenario_branches:
		txt += "T+" + str(b["turn"]) + " [P:" + str(b["prob"]) + "%] tau:" + ("%.2f" % b["tau"]) + " sigma:" + ("%.2f" % b["sigma"]) + "\n"
	scenario_label.text = txt

# ==========================================
# BOOK XXI & XXII INGESTION
# ==========================================
func _ingest_book_xxi():
	var env = get_node_or_null("WorldEnvironment")
	if env and env.environment: env.environment.ambient_light_color = Color(0.0, 0.3, 0.3)
	if not tensegrity_lines:
		tensegrity_lines = MeshInstance3D.new()
		var imm = ImmediateMesh.new(); tensegrity_lines.mesh = imm
		var lm = StandardMaterial3D.new(); lm.shading_mode = 0; lm.albedo_color = Color(1.0, 0.84, 0.0, 0.6); lm.emission_enabled = true; lm.emission = Color("#ffd700")
		tensegrity_lines.material_override = lm; add_child(tensegrity_lines)
		imm.surface_begin(Mesh.PRIMITIVE_LINES)
		for i in range(scar_nodes.size()):
			for j in range(i + 1, scar_nodes.size()):
				imm.surface_add_vertex(scar_nodes[i].global_position + Vector3(0, 1.25, 0))
				imm.surface_add_vertex(scar_nodes[j].global_position + Vector3(0, 1.25, 0))
		imm.surface_end()
	if not cross_current_particles:
		cross_current_particles = GPUParticles3D.new(); cross_current_particles.amount = 200; cross_current_particles.lifetime = 4.0
		var pm = ParticleProcessMaterial.new(); pm.direction = Vector3(0, 0, 1); pm.spread = 5.0; pm.initial_velocity_min = 2.0; pm.initial_velocity_max = 3.0; pm.color = Color(0.0, 0.898, 1.0, 0.4)
		cross_current_particles.process_material = pm; cross_current_particles.position = Vector3(0, 1.5, -4); add_child(cross_current_particles)
	telemetry["tau"] = clampf(telemetry["tau"] - 0.08, 0.0, 1.0); telemetry["sigma"] = 0.81
	append_to_ash({"event": "BOOK_XXI", "block": 2101, "parent": "7a3f8c2e91b04d16", "hash": "4e81a9f02b3c7d65"})
	oracle_log.text += "[color=#00e5ff][ BOOK XXI INGESTED ][/color] Registry of Choirs. Tensegrity locked. sigma=0.81.\n"

func _ingest_book_xxii():
	var env = get_node_or_null("WorldEnvironment")
	if env and env.environment: env.environment.background_color = Color(0.02, 0.0, 0.02)
	for i in range(4):
		var fw = MeshInstance3D.new(); var fm = CylinderMesh.new(); fm.top_radius = 0.3; fm.bottom_radius = 0.3; fm.height = 3.0; fw.mesh = fm
		var mat = StandardMaterial3D.new(); mat.albedo_color = Color(0.4, 0.0, 0.0); mat.emission_enabled = true; mat.emission = Color("#ff3d5a"); mat.emission_energy_multiplier = 2.0
		fw.material_override = mat; var a = i * (PI / 2.0) + PI / 4.0; fw.position = Vector3(cos(a) * 4.5, 1.5, sin(a) * 4.5); add_child(fw); thermal_flywheels.append(fw)
	telemetry["rho"] = 0.24; telemetry["sigma"] = 0.89
	append_to_ash({"event": "BOOK_XXII", "block": 2201, "parent": "4e81a9f02b3c7d65", "hash": "9d2c18fa34e760b1"})
	oracle_log.text += "[color=#b388ff][ BOOK XXII INGESTED ][/color] Siphon of Eras. Flywheels charged. rho=0.24, sigma=0.89.\n"

# ==========================================
# COMBAT & UTILITY
# ==========================================
func _on_combat_pressed():
	var result = run_multi_agent_combat()
	oracle_log.text += "[color=#ff3d5a][ N=4 COMBAT ][/color] Alpha(T) + Beta(F) + Gamma(B) + Shadow(N) = " + truth_names[result] + "\n"
	append_to_ash({"event": "MULTI_AGENT_COMBAT", "result": truth_names[result]})

func _on_seal_pressed():
	append_to_ash({"event": "MANUAL_SEAL", "stratum": stratum_names[current_stratum]})
	if current_stratum < LexStratum.AWAKENING: current_stratum += 1
	stratum_label.text = "LEX: " + stratum_names[current_stratum]
	oracle_log.text += "[color=#00ff9d]LEDGER SEALED[/color] | Ascended to " + stratum_names[current_stratum] + "\n"

func _on_reset_pressed():
	telemetry = {"tau": 0.44, "rho": 0.38, "delta": 0.35, "sigma": 0.72}
	reflexive_boundary_active = false; current_era = 0; turn_count = 0
	oracle_log.text += "[color=#ff3d5a]CHAMBER RESET[/color] | Maps remain.\n"

func _on_mute_pressed():
	audio_muted = !audio_muted; audio_player.volume_db = -80.0 if audio_muted else 0.0
	btn_mute.text = "UNMUTE" if audio_muted else "MUTE"

func _spawn_ghost(pos: Vector3, color: Color, scale_factor: float = 1.0):
	var ghost = MeshInstance3D.new(); ghost.mesh = ghost_mesh; ghost.position = pos; ghost.scale = Vector3.ONE * scale_factor
	var mat = StandardMaterial3D.new(); mat.shading_mode = 0; mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.albedo_color = Color(color.r, color.g, color.b, 0.8); mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	ghost.material_override = mat; ghost.set_meta("decay_rate", 0.001); add_child(ghost); ghosts.append(ghost)

func _trigger_deep_dive():
	oracle_log.text += "[color=#00e5ff][ DEEP DIVE ][/color] Merkle: " + merkle_root.substr(0, 16) + "... | Nodes: " + str(ash_chain.size()) + "\n"

func _update_ledger_ui():
	merkle_label.text = "MERKLE: " + merkle_root.substr(0, 16) + "..."
	node_count_label.text = "NODES: " + str(ash_chain.size())
	ledger_log.text = "[color=#00ff9d]SEALED[/color] #" + str(ash_chain[-1]["index"]) + " | " + ash_chain[-1]["stratum"] + "\n" + ledger_log.text

# ==========================================
# UI CONSTRUCTION
# ==========================================
func _build_ui():
	var canvas = CanvasLayer.new(); add_child(canvas)
	var ps = StyleBoxFlat.new(); ps.bg_color = Color(0.02, 0.02, 0.04, 0.85); ps.border_color = Color("#00e5ff"); ps.set_border_width_all(1); ps.set_corner_radius_all(8); ps.set_content_margin_all(12)
	var bs = StyleBoxFlat.new(); bs.bg_color = Color(0.05, 0.05, 0.1, 0.9); bs.border_color = Color("#00e5ff"); bs.set_border_width_all(1); bs.set_corner_radius_all(4); bs.set_content_margin_all(6)
	
	# HUD (Right)
	var hud = PanelContainer.new(); hud.anchor_left = 0.62; hud.anchor_right = 0.98; hud.anchor_top = 0.02; hud.anchor_bottom = 0.82
	hud.add_theme_stylebox_override("panel", ps); canvas.add_child(hud)
	var hs = ScrollContainer.new(); hud.add_child(hs)
	var hv = VBoxContainer.new(); hv.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hv.add_theme_constant_override("separation", 6); hs.add_child(hv)
	
	stratum_label = Label.new(); stratum_label.text = "LEX: PRIMORDIAL"; stratum_label.add_theme_color_override("font_color", Color("#00e5ff")); hv.add_child(stratum_label)
	era_label = Label.new(); era_label.text = "ERA: " + era_names[0]; era_label.add_theme_color_override("font_color", Color("#ffd700")); hv.add_child(era_label)
	turn_label = Label.new(); turn_label.text = "TURN: 0"; turn_label.add_theme_color_override("font_color", Color("#b388ff")); hv.add_child(turn_label)
	truth_label = Label.new(); truth_label.text = "TRUTH: N"; truth_label.add_theme_color_override("font_color", Color("#ffd700")); hv.add_child(truth_label)
	merkle_label = Label.new(); merkle_label.text = "MERKLE: 000..."; merkle_label.add_theme_color_override("font_color", Color("#00ff9d")); merkle_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; hv.add_child(merkle_label)
	node_count_label = Label.new(); node_count_label.text = "NODES: 0"; node_count_label.add_theme_color_override("font_color", Color("#b388ff")); hv.add_child(node_count_label)
	twin_label = Label.new(); twin_label.text = "TWIN: 16.2ms | 7.1ms | 24.5%"; twin_label.add_theme_color_override("font_color", Color("#4a4a5a")); hv.add_child(twin_label)
	
	var tg = GridContainer.new(); tg.columns = 2; hv.add_child(tg)
	for m in [{"l": "tau", "k": "tau", "c": Color("#ff3d5a")}, {"l": "rho", "k": "rho", "c": Color("#ffd700")}, {"l": "delta", "k": "delta", "c": Color("#b388ff")}, {"l": "sigma", "k": "sigma", "c": Color("#00e5ff")}]:
		var v = VBoxContainer.new(); var val = Label.new(); val.text = "0.00"; val.add_theme_font_size_override("font_size", 18); val.add_theme_color_override("font_color", m.c)
		telemetry_labels[m.k] = val; v.add_child(Label.new()); v.add_child(val); tg.add_child(v)
	
	var hz_title = Label.new(); hz_title.text = "HORIZON SCANNER:"; hz_title.add_theme_color_override("font_color", Color("#6b6b7b")); hv.add_child(hz_title)
	horizon_label = Label.new(); horizon_label.text = ""; horizon_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; hv.add_child(horizon_label)
	
	var sc_title = Label.new(); sc_title.text = "SCENARIO BRANCHES (+2):"; sc_title.add_theme_color_override("font_color", Color("#6b6b7b")); hv.add_child(sc_title)
	scenario_label = Label.new(); scenario_label.text = ""; scenario_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; hv.add_child(scenario_label)
	
	oracle_log = RichTextLabel.new(); oracle_log.bbcode_enabled = true; oracle_log.scroll_active = true; oracle_log.custom_minimum_size.y = 100; hv.add_child(oracle_log)
	ledger_log = RichTextLabel.new(); ledger_log.bbcode_enabled = true; ledger_log.scroll_active = true; ledger_log.custom_minimum_size.y = 60; hv.add_child(ledger_log)

	# Command Deck (Bottom)
	var deck = PanelContainer.new(); deck.anchor_left = 0.02; deck.anchor_right = 0.98; deck.anchor_top = 0.85; deck.anchor_bottom = 0.98
	var ds = StyleBoxFlat.new(); ds.bg_color = Color(0.01, 0.01, 0.02, 0.9); ds.border_color = Color("#2a2a35"); ds.set_border_width_all(1); ds.set_corner_radius_all(4)
	deck.add_theme_stylebox_override("panel", ds); canvas.add_child(deck)
	var dh = HBoxContainer.new(); dh.add_theme_constant_override("separation", 8); dh.alignment = BoxContainer.ALIGNMENT_CENTER; deck.add_child(dh)
	
	btn_draw = Button.new(); btn_draw.text = "DRAW"; btn_draw.add_theme_stylebox_override("normal", bs); btn_draw.add_theme_color_override("font_color", Color("#00e5ff")); btn_draw.pressed.connect(_on_draw_card_pressed); dh.add_child(btn_draw)
	btn_seal = Button.new(); btn_seal.text = "SEAL"; btn_seal.add_theme_stylebox_override("normal", bs); btn_seal.add_theme_color_override("font_color", Color("#00ff9d")); btn_seal.pressed.connect(_on_seal_pressed); dh.add_child(btn_seal)
	btn_combat = Button.new(); btn_combat.text = "N=4 COMBAT"; btn_combat.add_theme_stylebox_override("normal", bs); btn_combat.add_theme_color_override("font_color", Color("#ff3d5a")); btn_combat.pressed.connect(_on_combat_pressed); dh.add_child(btn_combat)
	btn_xxi = Button.new(); btn_xxi.text = "BOOK XXI"; btn_xxi.add_theme_stylebox_override("normal", bs); btn_xxi.add_theme_color_override("font_color", Color("#ffd700")); btn_xxi.pressed.connect(_ingest_book_xxi); dh.add_child(btn_xxi)
	btn_xxii = Button.new(); btn_xxii.text = "BOOK XXII"; btn_xxii.add_theme_stylebox_override("normal", bs); btn_xxii.add_theme_color_override("font_color", Color("#b388ff")); btn_xxii.pressed.connect(_ingest_book_xxii); dh.add_child(btn_xxii)
	btn_reset = Button.new(); btn_reset.text = "RESET"; btn_reset.add_theme_stylebox_override("normal", bs); btn_reset.add_theme_color_override("font_color", Color("#ff3d5a")); btn_reset.pressed.connect(_on_reset_pressed); dh.add_child(btn_reset)
	btn_mute = Button.new(); btn_mute.text = "MUTE"; btn_mute.add_theme_stylebox_override("normal", bs); btn_mute.add_theme_color_override("font_color", Color("#4a4a5a")); btn_mute.pressed.connect(_on_mute_pressed); dh.add_child(btn_mute)
