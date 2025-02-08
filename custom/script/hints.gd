extends Button

@onready var main_menu: VBoxContainer = $".."
@onready var hints_menu: VBoxContainer = $"../../Hints"
@onready var new_hint: Button = $"../../Hints/New Hint"
@onready var previous_hints: Button = $"../../Hints/Previous Hints"
@onready var back: Button = $"../../Hints/Back"
@onready var menu_container: MarginContainer = $"../../../.."
@onready var hints_back: Button = $"../../HintsDisplay/Back"
@onready var hints_display: VBoxContainer = $"../../HintsDisplay"

var enabled: bool = false

func _ready():
	self.pressed.connect(_on_hints_pressed)
	new_hint.pressed.connect(_on_new_hint_pressed)
	previous_hints.pressed.connect(_on_previous_hints_pressed)
	back.pressed.connect(_on_back_pressed)
	hints_back.pressed.connect(_on_hints_back_pressed)

func _on_hints_pressed():
	main_menu.visible = false
	hints_menu.visible = true
	
func _on_new_hint_pressed():
	_toggle_hints()

func _on_previous_hints_pressed():
	_toggle_hints()

func _on_back_pressed():
	main_menu.visible = true
	hints_menu.visible = false

func _on_hints_back_pressed():
	_toggle_hints()

func _toggle_hints():
	enabled = !enabled
	if enabled:
		hints_display.visible = true
		hints_menu.visible = false
		menu_container.add_theme_constant_override("margin_left", 200)
		menu_container.add_theme_constant_override("margin_right", 200)
		menu_container.add_theme_constant_override("margin_top", 0)
		menu_container.add_theme_constant_override("margin_bottom", 0)
	else:
		hints_display.visible = false
		hints_menu.visible = true
		menu_container.add_theme_constant_override("margin_left", 350)
		menu_container.add_theme_constant_override("margin_right", 350)
		menu_container.add_theme_constant_override("margin_top", 150)
		menu_container.add_theme_constant_override("margin_bottom", 150)
