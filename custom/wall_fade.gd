class_name WallManager
extends Node3D

var environment: bool = false
var first: bool = false
@onready var room2 = get_node("../../").get_node("Room2")
@onready var audio_manager = $AudioStreamPlayer3D

func _ready() -> void:
	toggle_visibility_of_all()

func toggle_visibility_of_all() -> void:
	environment = !environment
	room2.visible = !environment
	if first:
		if environment:
			audio_manager.switch_to_sea_ambiance()
		else:
			audio_manager.switch_to_space_ambiance()
	else:
		first = false
	for child in get_children():
		if child is Node3D and child.has_method("set_visible"):
			if child.name.begins_with("Environment"):
				child.visible = environment
			else:
				child.visible = !environment
				
	for child in get_children():
		if child is StaticBody3D and child.name.begins_with("Wall"):
			for grandchild in child.get_children():
				if grandchild is CollisionShape3D:
					grandchild.disabled = environment
