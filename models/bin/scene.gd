extends Node3D

func _ready():
	var anim_player = $AnimationPlayer  # Ajuste le chemin selon ta structure
	anim_player.play("Count")
	anim_player.get_animation("Count").loop_mode = Animation.LOOP_LINEAR
