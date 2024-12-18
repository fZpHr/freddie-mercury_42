extends XROrigin3D

var menu_visible = false

func teleport(new_position: Vector3):
	self.position = new_position

func _process(delta: float) -> void:
	if self.position.y < -0.6:
		teleport(Vector3(5, 2, 5))
