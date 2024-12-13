#class_name WallManager
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
			else:
				child.visible = visible_state
