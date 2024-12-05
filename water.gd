extends MeshInstance3D

@export var spawn_position: Vector3

func _on_area3d_body_entered(body: Node) -> void:
	print("body entered")
	if body.name == "Player":  # Adjust this to match your player node's name
		body.global_transform.origin = spawn_position
		if body.has_method("reset_player"):
			body.call("reset_player")  # Optional: Reset player state if needed
