extends Node3D

@onready var right_controller := $RightH
@onready var left_controller := $LeftH  
@onready var right_ray := $RightH/RayCast3D
@onready var left_ray := $LeftH/RayCast3D

var button_was_pressed := false

func _ready():
	## Désactive les rayons au démarrage
	#right_ray.visible = false
	#left_ray.visible = false
	#right_ray.enabled = false
	#left_ray.enabled = false
	pass

#func _process(_delta):
	#var button_is_pressed = left_controller.is_button_pressed("by_button")
	#
	## Active seulement quand on appuie sur le bouton (pas quand on le relâche)
	#if button_is_pressed and not button_was_pressed:
		#toggle_laser_pointers()
	#
	#button_was_pressed = button_is_pressed
#
#func toggle_laser_pointers():
	#right_ray.visible = !right_ray.visible
	#left_ray.visible = !left_ray.visible
	#right_ray.enabled = !right_ray.enabled
	#left_ray.enabled = !left_ray.enabled
