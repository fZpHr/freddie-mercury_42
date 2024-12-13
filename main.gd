extends Node3D

var xr_interface: XRInterface

func _ready():
	# Initialize XR interface
	$Player.position = Vector3(0, 42.249, 2.648)
	
	xr_interface = XRServer.find_interface("OpenXR")
	
	if xr_interface:
		print("OpenXR interface found")
	else:
		print("OpenXR interface not found")
	
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully")
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		get_viewport().use_xr = true
	else:
		print("OpenXR initialization failed")
		print(xr_interface)
		print(xr_interface.is_initialized())
