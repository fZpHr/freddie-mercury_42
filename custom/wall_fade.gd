class_name WallManager
extends Node3D
var visible_state: bool = true 
var environment: bool = false

func _ready() -> void:
	toggle_visibility_of_all()

func toggle_visibility_of_all() -> void:
	visible_state = !visible_state
	environment = !environment
	
	for child in get_children():
		if child is Node3D and child.has_method("set_visible"):
			if child.name.begins_with("Environment"):
				child.visible = environment
			#elif child.name.begins_with("Floor"):
				#var mesh = child.get_node("CollisionShape3D/MeshInstance3D")
				#if mesh:
					#if not mesh.material_override: 
						#mesh.material_override = StandardMaterial3D.new()
					#if environment:
						#mesh.material_override.albedo_color = Color8(0, 62, 9, 255)
					#else:
						#mesh.material_override.albedo_color = Color8(0, 0, 0, 255)
			else:
				child.visible = visible_state
