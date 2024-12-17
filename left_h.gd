extends Node3D

@onready var right_controller := $RightH
@onready var left_controller := $LeftH
@onready var right_ray := $RightH/FunctionPointer2
@onready var left_ray := $LeftH/FunctionPointer

func _ready():
	# Désactive les rayons au démarrage
	right_ray.visible = false
	left_ray.visible = false
	right_ray.enabled = false
	left_ray.enabled = false

func _process(_delta):
	# Vérifie si le bouton est pressé (par exemple le bouton Y/B)
	if left_controller.is_button_pressed("by_button"):
		toggle_laser_pointers()

func toggle_laser_pointers():
	# Inverse l'état des rayons
	right_ray.visible = !right_ray.visible
	left_ray.visible = !left_ray.visible
	right_ray.enabled = !right_ray.enabled
	left_ray.enabled = !left_ray.enabled
