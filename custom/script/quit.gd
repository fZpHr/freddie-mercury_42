extends Button
@onready var main_menu: VBoxContainer = $".."
@onready var confirmation: VBoxContainer = $"../../Confirmation"
@onready var yes: Button = $"../../Confirmation/Yes"
@onready var no: Button = $"../../Confirmation/No"

func _ready():
	self.pressed.connect(_on_quit_pressed)
	yes.pressed.connect(_on_yes_pressed)
	no.pressed.connect(_on_no_pressed)

func _on_quit_pressed():
	print("Quit button pressed!")
	main_menu.visible = false
	confirmation.visible = true
	
func _on_yes_pressed():
	get_tree().quit()

func _on_no_pressed():
	main_menu.visible = true
	confirmation.visible = false
