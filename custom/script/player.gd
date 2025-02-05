extends XROrigin3D

@onready var world_environment: WorldEnvironment = $"../WorldEnvironment"
@onready var environment : Environment = world_environment.environment
@onready var skybox: MeshInstance3D = $"../Map/Room1/Walls/Skybox"
@onready var map: Node3D = $"../Map"
@onready var victory_sound: AudioStreamPlayer3D = $"../Map/Room2/WinSoundEffect"

var xr_interface = XRServer.find_interface("OpenXR")
var menu_visible = false

func _ready():
	victory_sound.stream = preload("res://custom/audio/victory-sound-effect.mp3")
	victory_sound.unit_size = 5.0
	victory_sound.max_distance = 10.0

func teleport(new_position: Vector3):
	self.position = new_position
	
func _process(delta: float) -> void:
	if self.position.y < -0.6:
		teleport(Vector3(5, 2, 5))
	if self.position.z > 30.0:
		print("game finished !!!")
		victory_sound.play()
		switch_to_ar()
		skybox.visible = false
		map.visible = false

func switch_to_ar() -> bool:
	print("switching to ar")
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
	
	var light = DirectionalLight3D.new()
	add_child(light)
	light.light_energy = 1.0
	
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

	get_viewport().transparent_bg = false
	environment.background_mode = Environment.BG_SKY
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_BG
	return true
