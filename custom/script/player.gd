extends XROrigin3D

@onready var world_environment: WorldEnvironment = $"../WorldEnvironment"
@onready var environment : Environment = world_environment.environment
@onready var skybox: MeshInstance3D = $"../Map/Room1/Walls/Skybox"
@onready var map: Node3D = $"../Map"
@onready var victory_sound: AudioStreamPlayer3D = $"../Map/Room2/WinSoundEffect"
@onready var win_label: Label3D = $"../WinLabel"

var xr_interface = XRServer.find_interface("OpenXR")
var ar_light: DirectionalLight3D = null
var menu_visible = false
var game_won = false

func _ready():
	victory_sound.stream = preload("res://custom/audio/victory-sound-effect.mp3")
	victory_sound.unit_size = 5.0
	victory_sound.max_distance = 10.0

func teleport(new_position: Vector3):
	self.position = new_position
	
func _process(_delta: float) -> void:
	if self.position.y < -0.6:
		teleport(Vector3(5, 2, 5))
	if self.position.z > 30.0 and !game_won:
		victory_sound.play()
		game_won = true
		switch_to_ar()
		win_label.visible = true
		skybox.visible = false
		map.visible = false

func cancel_win():
	win_label.visible = false
	skybox.visible = true
	map.visible = true
	switch_to_vr()
	game_won = false

func switch_to_ar() -> bool:
	if xr_interface:
		var modes = xr_interface.get_supported_environment_blend_modes()
		if XRInterface.XR_ENV_BLEND_MODE_ALPHA_BLEND in modes:
			xr_interface.environment_blend_mode = XRInterface.XR_ENV_BLEND_MODE_ALPHA_BLEND
		elif XRInterface.XR_ENV_BLEND_MODE_ADDITIVE in modes:
			xr_interface.environment_blend_mode = XRInterface.XR_ENV_BLEND_MODE_ADDITIVE
		else:
			return false
	else:
		return false

	get_viewport().transparent_bg = true
	environment.background_mode = Environment.BG_CLEAR_COLOR
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(1, 1, 1, 1)
	environment.ambient_light_energy = 1.0
	
	ar_light = DirectionalLight3D.new()
	add_child(ar_light)
	ar_light.light_energy = 1.0
	
	return true

func switch_to_vr() -> bool:
	if xr_interface:
		var modes = xr_interface.get_supported_environment_blend_modes()
		if XRInterface.XR_ENV_BLEND_MODE_OPAQUE in modes:
			xr_interface.environment_blend_mode = XRInterface.XR_ENV_BLEND_MODE_OPAQUE
		else:
			return false
	else:
		return false

	if ar_light != null:
		ar_light.queue_free()
		ar_light = null

	get_viewport().transparent_bg = false
	environment.background_mode = Environment.BG_SKY
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_BG
	return true
