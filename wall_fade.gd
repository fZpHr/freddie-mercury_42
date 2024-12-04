class_name WallManager
extends Node3D  # Parent node that holds all walls and other components

@export var interval_time: float = 5.0

var visible_state: bool = true

func _ready() -> void:
	_start_wall_cycle()

func _start_wall_cycle() -> void:
	toggle_visibility_of_all()
	var timer = Timer.new()
	timer.wait_time = interval_time
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "_toggle_all_visibility"))
	add_child(timer)
	timer.start()

func _toggle_all_visibility() -> void:
	visible_state = !visible_state
	toggle_visibility_of_all()

# Toggle visibility of all relevant children
func toggle_visibility_of_all() -> void:
	
	# Loop through all child nodes of the parent node
	for child in get_children():
		if child is Node3D:  # Check if the child is of type Node3D or any subclass
			if child.has_method("set_visible"):
				child.visible = visible_state
