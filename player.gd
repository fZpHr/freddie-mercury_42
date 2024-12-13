extends XROrigin3D

var menu_visible = false

func teleport(new_position: Vector3, fade_duration: float = 1.5):
	self.position = new_position
