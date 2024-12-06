class_name WallManager
extends Node3D

var visible_state: bool = true 
var grass_visible: bool = false


func _ready() -> void:
	toggle_visibility_of_all()

func toggle_visibility_of_all() -> void:
	visible_state = !visible_state
	grass_visible = !grass_visible

	for child in get_children():
		if child is Node3D and child.has_method("set_visible"):
			if child.name.begins_with("Grass"):
				child.visible = grass_visible
			elif child.name.begins_with("Water"):
				child.visible = grass_visible
			elif child.name.begins_with("WindTrails"):
				child.visible = grass_visible
			else:
				child.visible = visible_state
