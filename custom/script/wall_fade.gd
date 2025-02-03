class_name WallManager
extends Node3D

var environment: bool = false
var first: bool = false
@onready var room2 = get_node("../../").get_node("Room2")
@onready var audio_manager = $AudioStreamPlayer3D
@onready var audio_manager2 = $AudioStreamPlayer3D2
@onready var audio_manager3 = $AudioStreamPlayer3D3
@onready var audio_manager4 = $AudioStreamPlayer3D4

func _ready() -> void:
	activate_environment()

func disable_collisions_recursive(node: Node, should_disable: bool) -> void:
	if node is CollisionShape3D:
		node.call_deferred("set_disabled", should_disable)
	elif node is CSGShape3D:
		node.use_collision = !should_disable
		node.collision_layer = 0 if should_disable else 1
		node.collision_mask = 0 if should_disable else 1
	
	for child in node.get_children():
		disable_collisions_recursive(child, should_disable)

func activate_environment() -> void:
	environment = true
	room2.visible = false
	
	if first:
		audio_manager.switch_to_sea_ambiance()
		audio_manager2.switch_to_sea_ambiance()
		audio_manager3.switch_to_sea_ambiance()
		audio_manager4.switch_to_sea_ambiance()
	else:
		audio_manager.switch_to_sea_ambiance()
		audio_manager2.switch_to_sea_ambiance()
		audio_manager3.switch_to_sea_ambiance()
		audio_manager4.switch_to_sea_ambiance()
		first = false
	
	# Handle visibility
	for child in get_children():
		if child is Node3D and child.has_method("set_visible"):
			if child.name.begins_with("Environment"):
				child.visible = true
				if child.name.begins_with("Tree"):
					disable_collisions_recursive(child, false)
			else:
				child.visible = false
	
	# Handle collisions
	for child in get_children():
		if child.name.begins_with("Wall"):
			disable_collisions_recursive(child, true)
		elif child is CSGShape3D and child.name.begins_with("WallDoor"):
			child.use_collision = false
			child.collision_layer = 0
			child.collision_mask = 0
			for inside in child.get_children():
				disable_collisions_recursive(inside, true)

func deactivate_environment() -> void:
	environment = false
	room2.visible = true
	
	if first:
		audio_manager.switch_to_space_ambiance()
		audio_manager2.switch_to_space_ambiance()
		audio_manager3.switch_to_space_ambiance()
		audio_manager4.switch_to_space_ambiance()
	else:
		audio_manager.switch_to_space_ambiance()
		audio_manager2.switch_to_space_ambiance()
		audio_manager3.switch_to_space_ambiance()
		audio_manager4.switch_to_space_ambiance()
		first = false
	
	# Handle visibility
	for child in get_children():
		if child is Node3D and child.has_method("set_visible"):
			if child.name.begins_with("Environment"):
				child.visible = false
				if child.name.begins_with("Tree"):
					disable_collisions_recursive(child, true)
			else:
				child.visible = true
	
	# Handle collisions
	for child in get_children():
		if child.name.begins_with("Wall"):
			disable_collisions_recursive(child, false)
		elif child is CSGShape3D and child.name.begins_with("WallDoor"):
			child.use_collision = true
			child.collision_layer = 1
			child.collision_mask = 1
			for inside in child.get_children():
				disable_collisions_recursive(inside, false)
