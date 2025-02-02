extends Button
@onready var main_menu: VBoxContainer = $".."

func _ready():
	self.pressed.connect(_on_load_pressed)

func _on_load_pressed():
	main_menu.visible = false
	
