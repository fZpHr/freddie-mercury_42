extends MarginContainer

func _ready():
	print("loaded hintsContaier")
	EventBus.toggle_hints_container.connect(_on_toggle_container)
	visible = false

func _on_toggle_container(show_new_hint: bool):
	visible = true
	if show_new_hint:
		print("Showing new hint for level: ", GameProgress.get_current_level())
	else:
		print("Showing previous hints for level: ", GameProgress.get_current_level())

func _on_back_pressed():
	visible = false
	EventBus.hints_container_closed.emit()
