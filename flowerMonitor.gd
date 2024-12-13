extends Node3D

@onready var flower_1: XRToolsPickable = %Flower1
@onready var flower_2: XRToolsPickable = %Flower2
@onready var flower_3: XRToolsPickable = %Flower3
@onready var flower_4: XRToolsPickable = %Flower4

var flowers = [flower_1, flower_2, flower_3, flower_4]

func _process(delta: float) -> void:
	for flower in flowers:
		if self.position.y < -0.3:
			flower.position = Vector3(5, 2, 5)
