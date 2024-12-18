extends Node3D

func start() -> void:
	$AnimationPlayer.play("fade_in")
	await $AnimationPlayer.animation_finished
	
	await get_tree().create_timer(3).timeout
	
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	
func begin() -> void:
	$AnimationPlayer.play("fade_in_long")
	await $AnimationPlayer.animation_finished
