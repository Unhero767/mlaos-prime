extends Node3D

var telemetry_targets = {"tau": 0.44, "rho": 0.38, "delta": 0.35, "sigma": 0.72}
var telemetry_current = {"tau": 0.44, "rho": 0.38, "delta": 0.35, "sigma": 0.72}
var telemetry_labels = {}
var scar_lights = []
var oculus_node = null
var altar_node = null
var time_elapsed = 0.0

var cam_pivot: Node3D
var cam: Camera3D
var cam_dist = 14.0
var cam_yaw = 0.7
var cam_pitch = 0.55
var dragging = false

var audio_player: AudioStreamPlayer
var playback: AudioStreamGeneratorPlayback
var audio_phase = 0.0

var oracle_log: RichTextLabel
var wargame_log: RichTextLabel

var http_state: HTTPRequest
var http_draw: HTTPRequest
var backend_url = "http://127.0.0.1:5000"

const TIERS = [
	{"min": 1, "max": 94, "name": "Prime Foundations", "spectral": "RED"},
	{"min": 95, "max": 188, "name": "Inner Mandala", "spectral": "EMERALD"},
	{"min": 189, "max": 282, "name": "Outer Choirs", "spectral": "GOLD"},
	{"min": 283, "max": 377, "name": "Inner Shadow Canon", "spectral": "OBSIDIAN"}
]

const STATES = {
	"T": "[color=#00ff9d]TRUE // Confirmed Fact[/color]",
	"F": "[color=#ff3d5a]FALSE // Verified Absence[/color]",
	"B": "[color=#ffd700]BOTH // Dialetheia[/color]",
	"N": "[color=#4a4a5a]NEITHER // Epistemic Void[/color]"
}

func _ready():
	_build_3d_chamber()
	_setup_camera()
	_setup_audio()
	_build_ui()
	oracle_log.text = "[i][color=#6b6b7b]Awaiting card draw...[/color][/i]\n[color=#00e5ff]Axiom: Resonance precedes form.[/color]"
	_populate_wargame_log()
	
	http_state = HTTPRequest.new()
	add_child(http_state)
	http_state.request_completed.connect(_on_state_received)
	_poll_state()
	
	http_draw = HTTPRequest.new()
	add_child(http_draw)
	http_draw.request_completed.connect(_on_draw_received)

func _poll_state():
	http_state.request(backend_url + "/api/rpg/state")
	await get_tree().create_timer(2.0).timeout
	_poll_state()

func _on_state_received(result, response_code, headers, body):
	if response_code == 200:
		var json = JSON.parse_string(body.get_string_from_utf8())
		if json and json.has("tau"):
			telemetry_targets["tau"] = float(json["tau"])
			telemetry_targets["rho"] = float(json["rho"])
			telemetry_targets["delta"] = float(json["delta"])
			telemetry_targets["sigma"] = float(json["sigma"])

func _setup_camera():
	cam = get_node_or_null("Camera3D")
	if not cam:
		cam = Camera3D.new()
		add_child(cam)
	cam_pivot = Node3D.new()
	add_child(cam_pivot)
	cam.reparent(cam_pivot)
	_update_cam_pos()

func _update_cam_pos():
	var x = cam_dist * sin(cam_pitch) * sin(cam_yaw)
	var y = cam_dist * cos(cam_pitch)
	var z = cam_dist * sin(cam_pitch) * cos(cam_yaw)
	cam.position = Vector3(x, y, z)
	cam.look_at(Vector3(0, 1, 0))

func _setup_audio():
	audio_player = AudioStreamPlayer.new()
	var gen = AudioStreamGenerator.new()
	gen.mix_rate = 22050.0
	gen.buffer_length = 0.1
	audio_player.stream = gen
	add_child(audio_player)
	audio_player.play()
	playback = audio_player.get_stream_playback()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			cam_dist = max(5.0, cam_dist - 1.0)
			_update_cam_pos()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			cam_dist = min(25.0, cam_dist + 1.0)
			_update_cam_pos()
	elif event is InputEventMouseMotion and dragging:
		cam_yaw -= event.relative.x * 0.005
		cam_pitch = clampf(cam_pitch - event.relative.y * 0.005, 0.15, 1.4)
		_update_cam_pos()

func _process(delta):
	time_elapsed += delta
	for key in telemetry_current:
		telemetry_current[key] = lerp(telemetry_current[key], telemetry_targets[key], delta * 2.5)
		if telemetry_labels.has(key):
			telemetry_labels[key].text = "%.2f" % telemetry_current[key]
	if oculus_node:
		oculus_node.rotation.y += delta * 1.5
		oculus_node.position.y = 0.6 + sin(time_elapsed * 3.0) * 0.1
	if altar_node:
		altar_node.rotation.y -= delta * 0.5
	for light in scar_lights:
		light.light_energy = 1.25 + sin(time_elapsed * 4.0) * 0.75
	_process_audio()

func _process_audio():
	if not playback: return
	var frames = playback.get_frames_available()
	for i in range(frames):
		var sample = sin(audio_phase * TAU) * 0.04
		playback.push_frame(Vector2(sample, sample))
		audio_phase += 130.81 / 22050.0
		if audio_phase >= 1.0: audio_phase -= 1.0

func _build_3d_chamber():
	var floor_mesh = BoxMesh.new()
	floor_mesh.size = Vector3(0.9, 0.2, 0.9)
	var pillar_mesh = BoxMesh.new()
	pillar_mesh.size = Vector3(0.6, 2.5, 0.6)
	var altar_mesh = CylinderMesh.new()
	altar_mesh.top_radius = 0.4
	altar_mesh.bottom_radius = 0.5
	altar_mesh.height = 0.8
	var oculus_mesh = SphereMesh.new()
	oculus_mesh.radius = 0.4
	oculus_mesh.height = 0.8
	for z in range(8):
		for x in range(8):
			var pos_x = (x - 3.5) * 1.0
			var pos_z = (z - 3.5) * 1.0
			var mat = StandardMaterial3D.new()
			mat.albedo_color = Color("#161620")
			mat.roughness = 0.8
			var mesh_inst = MeshInstance3D.new()
			mesh_inst.mesh = floor_mesh
			mesh_inst.position = Vector3(pos_x, 0, pos_z)
			if (x == 3 or x == 4) and z == 0:
				mat.albedo_color = Color("#00e5ff"); mat.emission_enabled = true; mat.emission = Color("#00e5ff")
			elif (x == 3 or x == 4) and z == 7:
				mat.albedo_color = Color("#ff3d5a"); mat.emission_enabled = true; mat.emission = Color("#ff3d5a")
			elif x == 0 and (z == 3 or z == 4):
				mat.albedo_color = Color("#4a4a5a")
			elif x == 7 and (z == 3 or z == 4):
				mat.albedo_color = Color("#ffd700"); mat.emission_enabled = true; mat.emission = Color("#ffd700")
			elif (x == 2 or x == 5) and (z == 2 or z == 5):
				var pillar = MeshInstance3D.new()
				pillar.mesh = pillar_mesh; pillar.position = Vector3(pos_x, 1.25, pos_z)
				var p_mat = StandardMaterial3D.new()
				p_mat.albedo_color = Color("#b388ff"); p_mat.emission_enabled = true; p_mat.emission = Color("#b388ff")
				pillar.material_override = p_mat; add_child(pillar)
				var light = OmniLight3D.new()
				light.light_color = Color("#b388ff"); light.light_energy = 1.25; light.omni_range = 3.0
				light.position = Vector3(pos_x, 2.5, pos_z); add_child(light); scar_lights.append(light)
				mat.albedo_color = Color("#b388ff")
				_add_particles(Vector3(pos_x, 2.5, pos_z), Color("#b388ff"), 30)
			elif x == 3 and z == 3:
				mat.albedo_color = Color("#992436")
				altar_node = MeshInstance3D.new(); altar_node.mesh = altar_mesh; altar_node.position = Vector3(pos_x, 0.4, pos_z)
				var a_mat = StandardMaterial3D.new()
				a_mat.albedo_color = Color("#ff3d5a"); a_mat.emission_enabled = true; a_mat.emission = Color("#ff3d5a")
				altar_node.material_override = a_mat; add_child(altar_node)
				_add_particles(Vector3(pos_x, 1.0, pos_z), Color("#ff3d5a"), 50)
			elif x == 4 and z == 4:
				mat.albedo_color = Color("#0099aa")
				oculus_node = MeshInstance3D.new(); oculus_node.mesh = oculus_mesh; oculus_node.position = Vector3(pos_x, 0.6, pos_z)
				var o_mat = StandardMaterial3D.new()
				o_mat.albedo_color = Color("#00e5ff"); o_mat.emission_enabled = true; o_mat.emission = Color("#00e5ff")
				oculus_node.material_override = o_mat; add_child(oculus_node)
				_add_particles(Vector3(pos_x, 1.0, pos_z), Color("#00e5ff"), 40)
			mesh_inst.material_override = mat; add_child(mesh_inst)

func _add_particles(pos: Vector3, color: Color, amount: int):
	var p = GPUParticles3D.new(); p.amount = amount; p.lifetime = 2.0; p.emitting = true
	var m = ParticleProcessMaterial.new()
	m.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE; m.emission_sphere_radius = 0.3
	m.direction = Vector3(0, 1, 0); m.spread = 20.0; m.initial_velocity_min = 0.3; m.initial_velocity_max = 1.0
	m.gravity = Vector3(0, -0.3, 0); m.color = color; m.scale_min = 0.02; m.scale_max = 0.06
	p.process_material = m; p.position = pos; add_child(p)

func _build_ui():
	var canvas = CanvasLayer.new(); add_child(canvas)
	
	# --- TOP LEFT: TACTICAL MINIMAP ---
	var mm_panel = PanelContainer.new()
	mm_panel.set_anchors_preset(Control.PRESET_TOP_LEFT)
	mm_panel.offset_left = 20; mm_panel.offset_top = 20; mm_panel.offset_right = 340; mm_panel.offset_bottom = 380
	var mm_style = StyleBoxFlat.new()
	mm_style.bg_color = Color(0.05, 0.05, 0.08, 0.85); mm_style.border_color = Color("#2a2a35")
	mm_style.set_border_width_all(1); mm_style.set_corner_radius_all(8); mm_style.set_content_margin_all(16)
	mm_panel.add_theme_stylebox_override("panel", mm_style); canvas.add_child(mm_panel)
	
	var mm_vbox = VBoxContainer.new(); mm_panel.add_child(mm_vbox)
	var mm_title = Label.new(); mm_title.text = "TACTICAL MINIMAP // 8x8"
	mm_title.add_theme_font_size_override("font_size", 14); mm_title.add_theme_color_override("font_color", Color("#00e5ff"))
	mm_vbox.add_child(mm_title)
	
	var mm_grid = GridContainer.new(); mm_grid.columns = 8
	mm_grid.add_theme_constant_override("h_separation", 3); mm_grid.add_theme_constant_override("v_separation", 3)
	mm_vbox.add_child(mm_grid)
	
	for z in range(8):
		for x in range(8):
			var cell = ColorRect.new(); cell.custom_minimum_size = Vector2(32, 32)
			var c = Color("#161620")
			if (x == 3 or x == 4) and z == 0: c = Color("#00e5ff")
			elif (x == 3 or x == 4) and z == 7: c = Color("#ff3d5a")
			elif x == 0 and (z == 3 or z == 4): c = Color("#4a4a5a")
			elif x == 7 and (z == 3 or z == 4): c = Color("#ffd700")
			elif (x == 2 or x == 5) and (z == 2 or z == 5): c = Color("#b388ff")
			elif x == 3 and z == 3: c = Color("#992436")
			elif x == 4 and z == 4: c = Color("#0099aa")
			cell.color = c; mm_grid.add_child(cell)
	
	var mm_legend = Label.new()
	mm_legend.text = "[color=#00e5ff]■[/color] North  [color=#ff3d5a]■[/color] South  [color=#b388ff]■[/color] Scar"
	mm_legend.add_theme_font_size_override("font_size", 10); mm_vbox.add_child(mm_legend)

	# --- RIGHT SIDE: TELEMETRY & ORACLE ---
	var right_panel = PanelContainer.new()
	right_panel.anchor_left = 0.62; right_panel.anchor_right = 0.98
	right_panel.anchor_top = 0.03; right_panel.anchor_bottom = 0.97
	var r_style = StyleBoxFlat.new()
	r_style.bg_color = Color(0.05, 0.05, 0.08, 0.85); r_style.border_color = Color("#2a2a35")
	r_style.set_border_width_all(1); r_style.set_corner_radius_all(8); r_style.set_content_margin_all(20)
	right_panel.add_theme_stylebox_override("panel", r_style); canvas.add_child(right_panel)
	
	var r_scroll = ScrollContainer.new(); right_panel.add_child(r_scroll)
	var r_vbox = VBoxContainer.new()
	r_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL; r_vbox.add_theme_constant_override("separation", 16)
	r_scroll.add_child(r_vbox)
	
	var header = Label.new(); header.text = "WAR-GAMES // COMMAND CONSOLE"
	header.add_theme_font_size_override("font_size", 18); header.add_theme_color_override("font_color", Color("#00e5ff"))
	r_vbox.add_child(header)
	
	var tel_title = Label.new(); tel_title.text = "Live Telemetry // 130.81 Hz Carrier"
	tel_title.add_theme_color_override("font_color", Color("#6b6b7b")); r_vbox.add_child(tel_title)
	
	var tel_grid = GridContainer.new(); tel_grid.columns = 2; tel_grid.add_theme_constant_override("h_separation", 16)
	r_vbox.add_child(tel_grid)
	
	var metrics = [
		{"label": "Political Tension (τ)", "key": "tau", "color": Color("#ff3d5a")},
		{"label": "Resource Scarcity (ρ)", "key": "rho", "color": Color("#ffd700")},
		{"label": "Faction Drift (δ)", "key": "delta", "color": Color("#b388ff")},
		{"label": "Systemic Coherence (σ)", "key": "sigma", "color": Color("#00e5ff")}
	]
	for m in metrics:
		var v = VBoxContainer.new(); var l = Label.new(); l.text = m.label
		l.add_theme_font_size_override("font_size", 12); l.add_theme_color_override("font_color", Color("#6b6b7b"))
		var val = Label.new(); val.text = "0.00"; val.add_theme_font_size_override("font_size", 24)
		val.add_theme_color_override("font_color", m.color); telemetry_labels[m.key] = val
		v.add_child(l); v.add_child(val); tel_grid.add_child(v)
	
	var oracle_title = Label.new(); oracle_title.text = "Persona Oracle // 377-Card"
	oracle_title.add_theme_color_override("font_color", Color("#6b6b7b")); r_vbox.add_child(oracle_title)
	
	var draw_btn = Button.new(); draw_btn.text = "Draw Oracle Card"
	draw_btn.pressed.connect(_on_draw_card_pressed); r_vbox.add_child(draw_btn)
	
	oracle_log = RichTextLabel.new(); oracle_log.bbcode_enabled = true; oracle_log.scroll_active = true
	oracle_log.custom_minimum_size.y = 150; r_vbox.add_child(oracle_log)
	
	var wg_title = Label.new(); wg_title.text = "Paraconsistent Wargame // N=4"
	wg_title.add_theme_color_override("font_color", Color("#6b6b7b")); r_vbox.add_child(wg_title)
	
	wargame_log = RichTextLabel.new(); wargame_log.bbcode_enabled = true; wargame_log.scroll_active = true
	wargame_log.custom_minimum_size.y = 120; r_vbox.add_child(wargame_log)

func _on_draw_card_pressed():
	var err = http_draw.request(backend_url + "/api/oracle/draw")
	if err != OK: _fallback_draw()

func _on_draw_received(result, response_code, headers, body):
	if response_code == 200:
		var json = JSON.parse_string(body.get_string_from_utf8())
		if json and json.has("card_num"): _render_oracle_log(json); return
	_fallback_draw()

func _fallback_draw():
	var card_num = randi_range(1, 377); var tier = TIERS[0]
	for t in TIERS:
		if card_num >= t.min and card_num <= t.max: tier = t; break
	var state_keys = STATES.keys(); var state = state_keys[randi_range(0, state_keys.size() - 1)]
	_render_oracle_log({"card_num": card_num, "tier": tier.name, "spectral": tier.spectral, "phase": randf_range(0, TAU), "interference": randf_range(0.5, 3.0), "state": state})

func _render_oracle_log(json):
	var card_num = json.get("card_num", 0); var tier = json.get("tier", "Unknown")
	var spectral = json.get("spectral", "NULL"); var phase = json.get("phase", 0.0)
	var interference = json.get("interference", 0.0); var state = json.get("state", "N")
	var log_entry = "[color=#ffd700]Card #%d[/color] | Tier: [color=#b388ff]%s[/color]\n" % [card_num, tier]
	log_entry += "Spectral: %s | Phase: %.3f rad\n" % [spectral, phase]
	log_entry += "Interference I(w): [color=#00e5ff]%.3f[/color]\n" % interference
	log_entry += "Belnap Resolution: %s\n" % STATES.get(state, STATES["N"])
	if state == "B": log_entry += "[color=#ffd700]-> Harmonic Scar formed. c=0.28[/color]"
	oracle_log.text = log_entry + "\n\n" + oracle_log.text
	telemetry_targets["sigma"] = randf_range(0.85, 1.0)

func _populate_wargame_log():
	var wg_text = "[color=#00e5ff][b]--- ROUND 1 ---[/b][/color]\n"
	wg_text += "[color=#ff3d5a]Choir Alpha[/color] [T] vs [color=#00ff9d]Choir Beta[/color] [F]\n"
	wg_text += "[color=#ffd700]-> Dialetheic collision (T+F->B). Scar petrified. c=0.28[/color]\n\n"
	wg_text += "[color=#00ff9d][b]Wargame Concluded: Bilattice Join [B] | Scars: 4 | sigma=1.00[/b][/color]"
	wargame_log.text = wg_text
