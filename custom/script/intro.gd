extends Node3D

func start() -> void:
	$"../Player/LeftH/MovementDirect".enabled = false
	$"../Player/LeftH/MovementSprint".enabled = false
	$"../Map/Room1".visible = false
	$AnimationPlayer.play("fade_in")
	await $AnimationPlayer.animation_finished
	
	await get_tree().create_timer(3).timeout
	
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	await get_tree().create_timer(2).timeout
	$"../Player".position = Vector3(0, 202, 0)
	$"../Map/Room1".visible = true
	await begin()
	$"../Player/LeftH/MovementDirect".enabled = true
	$"../Player/LeftH/MovementSprint".enabled = true
	self.visible = false
	
func begin() -> void:
	$AnimationPlayer.play("fade_in_long")
	await $AnimationPlayer.animation_finished
