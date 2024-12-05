class_name WallManager
extends Node3D

@export var interval_time: float = 5.0

var visible_state: bool = true

func _ready() -> void:
	_start_wall_cycle()

func _start_wall_cycle() -> void:
	toggle_visibility_and_collision_of_all()
	var timer = Timer.new()
	timer.wait_time = interval_time
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "_toggle_all_visibility_and_collision"))
	add_child(timer)
	timer.start()

func _toggle_all_visibility_and_collision() -> void:
	visible_state = !visible_state
	toggle_visibility_and_collision_of_all()

func toggle_visibility_and_collision_of_all() -> void:
	for child in get_children():
		if child is Node3D:
			# Toggle visibility
			child.visible = visible_state
			# Toggle collision if the child has a CollisionShape3D
			if child.has_node("CollisionShape3D"):
				var collision_shape = child.get_node("CollisionShape3D") as CollisionShape3D
				collision_shape.disabled = !visible_state
