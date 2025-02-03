extends Node3D

@onready var wall = get_node("../../").get_node("Walls")
@onready var door: DoorComponent = $"../../Walls/WallDoor/AnimatableBody3D/DoorComponent"

var target_positions = []
var correct_positions = {
	&"Flower1": "Area3D1",
	&"Flower2": "Area3D3",
	&"Flower3": "Area3D2",
	&"Flower4": "Area3D4"
}
var puzzle_solved = false

func _ready():
	print("Initializing flower game...")
	for i in range(1, 5):
		var static_body = get_node("StaticBody3D" + str(i))
		if static_body:
			var pos = static_body.position + Vector3(0, 4, 1)
			target_positions.append(pos)
	
	for i in range(1, 5):
		var area = get_node("Area3D" + str(i))
		if area:
			area.body_entered.connect(_on_body_entered)
			area.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D):
	print("Body entered: ", body.name)
	var area_num = get_area_number(body)
	if area_num != -1 and area_num <= len(target_positions):
		# Position et rotation
		body.position = target_positions[area_num - 1]
		body.rotation_degrees = Vector3(90, 0, 180)
		
		# Réinitialisation de la vélocité
		if body is RigidBody3D:
			body.linear_velocity = Vector3.ZERO
			body.angular_velocity = Vector3.ZERO
		elif body is CharacterBody3D:
			body.velocity = Vector3.ZERO
		
	check_all_positions(body)

func get_area_number(body: Node3D) -> int:
	var parent = body.get_parent()
	var areas = parent.get_children().filter(func(node): return node.name.begins_with("Area"))
	for area in areas:
		if area.has_overlapping_bodies() and area.get_overlapping_bodies().has(body):
			return int(area.name.trim_prefix("Area3D"))
	return -1

func _on_body_exited(body: Node3D):
	print("Body exited: ", body.name)
	check_all_positions(body)

func check_all_positions(body: Node3D):
	var all_correct = true
	print("\nChecking flower positions:")
	
	var parent = body.get_parent()
	var areas = parent.get_children().filter(func(node): return node.name.begins_with("Area"))
	
	for flower_name in correct_positions:
		var flower = get_node(str(flower_name))
		if flower:
			var current_area = "none"
			for area in areas:
				if area.has_overlapping_bodies() and area.get_overlapping_bodies().has(flower):
					current_area = area.name
					break
					
			print(str(flower_name) + " is in " + current_area + ", should be in " + correct_positions[flower_name])
			if current_area != correct_positions[flower_name]:
				all_correct = false
	
	print("All positions correct:", all_correct)
	
	if all_correct and !puzzle_solved:
		print("Puzzle completed! Toggling walls...")
		puzzle_solved = true
		GameProgress.complete_level("level1")
		wall.deactivate_environment()
		if door:
			door.is_active = true
			door.start_door_cycle()
	elif !all_correct and puzzle_solved:
		print("Puzzle broken! Reverting walls...")
		puzzle_solved = false
		wall.activate_environment()
		if door:
			door.is_active = false
			door.stop_door_cycle()
