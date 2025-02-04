extends Node3D

var xr_interface: XRInterface
@onready var environment : Environment = $WorldEnvironment.environment

func _ready():
	
	xr_interface = XRServer.find_interface("OpenXR")
	
	if xr_interface:
		print("OpenXR interface found")
	else:
		print("OpenXR interface not found")
	
	if xr_interface and xr_interface.is_initialized():
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		get_viewport().use_xr = true
	else:
		print(xr_interface)
		print(xr_interface.is_initialized())
	$Player/LeftH/MovementDirect.enabled = false
	$Player/LeftH/MovementSprint.enabled = false
	$Map/Room1.visible = false
	await $Intro.start()
	await get_tree().create_timer(2).timeout
	$Player.position = Vector3(0, 202, 0)
	$Map/Room1.visible = true
	await $Intro.begin()
	$Player/LeftH/MovementDirect.enabled = true
	$Player/LeftH/MovementSprint.enabled = true
	$Intro.visible = false
	
	#toggle_loop()


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

func _on_detector_toggled(is_on):
	if is_on:
		if !switch_to_ar():
			$ARToggle.on = false
	else:
		if !switch_to_vr():
			$ARToggle.on = true
