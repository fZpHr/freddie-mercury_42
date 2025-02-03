extends Button
@onready var main_menu: VBoxContainer = $".."
@onready var hints_menu: VBoxContainer = $"../../Hints"
@onready var new_hint: Button = $"../../Hints/New Hint"
@onready var previous_hints: Button = $"../../Hints/Previous Hints"
@onready var back: Button = $"../../Hints/Back"

func _ready():
	self.pressed.connect(_on_hints_pressed)
	new_hint.pressed.connect(_on_new_hint_pressed)
	previous_hints.pressed.connect(_on_previous_hints_pressed)
	back.pressed.connect(_on_back_pressed)	

func _on_hints_pressed():
	main_menu.visible = false
	hints_menu.visible = true
	
func _on_new_hint_pressed():
	hints_menu.visible = false

func _on_previous_hints_pressed():
	hints_menu.visible = false

func _on_back_pressed():
	main_menu.visible = true
	hints_menu.visible = false
