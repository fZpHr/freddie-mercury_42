class_name DoorComponent
extends Node

@export var direction: Vector3 = Vector3(0, 1, 0)
@export var door_size: Vector3 = Vector3(0, 2, 0)
@export var speed: float = 0.5
@export var transition: Tween.TransitionType = Tween.TRANS_LINEAR
@export var easing: Tween.EaseType = Tween.EASE_IN_OUT
@export var min_wait_time: float = 0.5
@export var max_wait_time: float = 2.0
@export var malfunction_chance: float = 0.3

var parent: Node
var orig_pos: Vector3
var door_open_sound: AudioStreamPlayer3D
var door_close_sound: AudioStreamPlayer3D
var is_door_open: bool = false
var is_moving: bool = false
var is_active: bool = false

func _ready() -> void:
	parent = get_parent()
	orig_pos = parent.global_position
	await get_tree().create_timer(0.1).timeout  # Attendre un court instant
	setup_audio()

func setup_audio() -> void:
	door_open_sound = AudioStreamPlayer3D.new()
	door_open_sound.stream = preload("res://custom/audio/sci_fi_door-6451.mp3")
	door_open_sound.unit_size = 3
	door_open_sound.max_db = 0
	door_open_sound.max_distance = 10
	door_open_sound.pitch_scale = 1.0
	add_child(door_open_sound)
	
	door_close_sound = AudioStreamPlayer3D.new()
	door_close_sound.stream = preload("res://custom/audio/metal-moving-81780.mp3")
	door_close_sound.unit_size = 3
	door_close_sound.max_db = 0
	door_close_sound.max_distance = 10
	door_close_sound.pitch_scale = -1.0
	add_child(door_close_sound)

func play_sound(sound: AudioStreamPlayer3D) -> void:
	if sound and is_instance_valid(sound) and sound.is_inside_tree():
		sound.global_position = parent.global_position
		sound.play()

func start_door_cycle() -> void:
	is_active = true
	malfunction_cycle()

func stop_door_cycle() -> void:
	is_active = false
	is_moving = false
	if parent.global_position != orig_pos:
		var tween = create_tween()
		tween.tween_property(parent, "global_position", orig_pos, speed)
		is_door_open = false

func malfunction_cycle() -> void:
	if not is_moving and is_active:
		if is_door_open:
			close_door_malfunction()
		else:
			open_door_malfunction()

func get_random_wait_time() -> float:
	return randf_range(min_wait_time, max_wait_time)

func open_door_malfunction() -> void:
	if !is_active:
		return
	is_moving = true
	var tween = create_tween()
	var target_pos = orig_pos + (direction * door_size)
	
	if randf() < malfunction_chance:
		target_pos = orig_pos + (direction * door_size * randf_range(0.3, 0.7))
	
	play_sound(door_open_sound)
	tween.tween_property(parent, "global_position", target_pos, speed)
	tween.tween_callback(func():
		is_door_open = true
		is_moving = false
		if is_active:
			await get_tree().create_timer(get_random_wait_time()).timeout
			malfunction_cycle()
	)
	play_sound(door_close_sound)

func close_door_malfunction() -> void:
	if !is_active:
		return
	is_moving = true
	var tween = create_tween()
	
	var partial_close = randf() < malfunction_chance
	var target_pos = orig_pos
	if partial_close:
		var current_offset = parent.global_position - orig_pos
		target_pos = orig_pos + (current_offset * randf_range(0.3, 0.7))
	
	play_sound(door_open_sound)
	tween.tween_property(parent, "global_position", target_pos, speed)
	tween.tween_callback(func():
		if not partial_close:
			is_door_open = false
		is_moving = false
		if is_active:
			await get_tree().create_timer(get_random_wait_time()).timeout
			malfunction_cycle()
	)
	play_sound(door_close_sound)
