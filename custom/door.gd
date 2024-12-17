extends Node

@export var direction: Vector3 = Vector3(0, 1, 0)
@export var door_size: Vector3 = Vector3(0, 2, 0)
@export var speed: float = 0.5
@export var transition: Tween.TransitionType = Tween.TRANS_LINEAR
@export var easing: Tween.EaseType = Tween.EASE_IN_OUT
@export var interval_time: float = 5.0

var parent: Node
var orig_pos: Vector3

func _ready() -> void:
	parent = get_parent()
	orig_pos = parent.global_position
	_start_door_cycle()

func _start_door_cycle() -> void:
	open_door()
	var timer = Timer.new()
	timer.wait_time = interval_time
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "_toggle_door"))
	add_child(timer)
	timer.start()

func _toggle_door() -> void:
	if is_close_enough(parent.global_position, orig_pos):
		open_door()
	else:
		close_door()

func is_close_enough(pos1: Vector3, pos2: Vector3, tolerance: float = 0.01) -> bool:
	return pos1.distance_to(pos2) < tolerance

func open_door() -> void:
	var tween = get_tree().create_tween()
	var target_pos = orig_pos + (direction * door_size)
	tween.tween_property(parent, "global_position", target_pos, speed).set_trans(transition).set_ease(easing)

func close_door() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(parent, "global_position", orig_pos, speed).set_trans(transition).set_ease(easing)
