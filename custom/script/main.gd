extends Node3D

var xr_interface: XRInterface

const TRANS_EN = preload("res://custom/translations/translations.en.translation")
const TRANS_ES = preload("res://custom/translations/translations.es.translation")
const TRANS_FR = preload("res://custom/translations/translations.fr.translation")

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

	await load_translations()
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

func load_translations() -> void:
	TranslationServer.add_translation(TRANS_EN)
	TranslationServer.add_translation(TRANS_ES)
	TranslationServer.add_translation(TRANS_FR)
