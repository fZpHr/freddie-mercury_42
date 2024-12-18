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
	toggle_visibility_of_all()

func disable_collisions_recursive(node: Node, should_disable: bool) -> void:
	if node is CollisionShape3D:
		node.call_deferred("set_disabled", should_disable)
	elif node is CSGShape3D:
		node.use_collision = !should_disable
		node.collision_layer = 0 if should_disable else 1
		node.collision_mask = 0 if should_disable else 1
	
	for child in node.get_children():
		disable_collisions_recursive(child, should_disable)

func toggle_visibility_of_all() -> void:
	environment = !environment
	room2.visible = !environment
	
	if first:
		audio_manager.switch_to_sea_ambiance()
		audio_manager2.switch_to_sea_ambiance()
		audio_manager3.switch_to_sea_ambiance()
		audio_manager4.switch_to_sea_ambiance()
	else:
		if environment:
			audio_manager.switch_to_sea_ambiance()
			audio_manager2.switch_to_sea_ambiance()
			audio_manager3.switch_to_sea_ambiance()
			audio_manager4.switch_to_sea_ambiance()
		else:
			audio_manager.switch_to_space_ambiance()
			audio_manager2.switch_to_space_ambiance()
			audio_manager3.switch_to_space_ambiance()
			audio_manager4.switch_to_space_ambiance()
		first = false
	
	# Gérer la visibilité
	for child in get_children():
		if child is Node3D and child.has_method("set_visible"):
			if child.name.begins_with("Environment"):
				child.visible = environment
				if child.name.begins_with("Tree"):
					disable_collisions_recursive(child, !environment)
			else:
				child.visible = !environment
	
	# Gérer les collisions récursivement
	for child in get_children():
		if child.name.begins_with("Wall"):
			disable_collisions_recursive(child, environment)
		elif child is CSGShape3D and child.name.begins_with("WallDoor"):
			child.use_collision = !environment
			child.collision_layer = 0 if environment else 1
			child.collision_mask = 0 if environment else 1
			for inside in child.get_children():
				disable_collisions_recursive(inside, environment)
