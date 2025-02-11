extends Node3D

var xr_interface: XRInterface

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

	await $Intro.start()
