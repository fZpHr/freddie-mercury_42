extends Button
@onready var main_menu: VBoxContainer = $".."
@onready var load_menu: VBoxContainer = $"../../Load"
@onready var tutorial_btn: Button = $"../../Load/Tutorial"
@onready var level1_btn: Button = $"../../Load/Level 1"
@onready var level2_btn: Button = $"../../Load/Level 2"
@onready var back_btn: Button = $"../../Load/Back"
@onready var start: Button = $"../Start"
@onready var hints: Button = $"../Hints"
@onready var player: XROrigin3D = get_node("/root/main/Player")
@onready var hub:  = get_node("/root/main/Map/Hub")
@onready var wall = get_node("/root/main/Map/Room1/Walls")

var initial_flower_positions = {}
var flowers = []

func _ready():
	self.pressed.connect(_on_load_pressed)
	tutorial_btn.pressed.connect(_on_tutorial_pressed)
	level1_btn.pressed.connect(_on_level1_pressed)
	level2_btn.pressed.connect(_on_level2_pressed)
	back_btn.pressed.connect(_on_back_pressed)
	update_buttons()
	
	flowers = [
		get_node("/root/main/Map/Room1/Object/Area/Flower1"),
		get_node("/root/main/Map/Room1/Object/Area/Flower2"),
		get_node("/root/main/Map/Room1/Object/Area/Flower3"),
		get_node("/root/main/Map/Room1/Object/Area/Flower4")
	]
	for flower in flowers:
		if flower:
			initial_flower_positions[flower] = flower.global_position

func reset_flowers():
	for flower in flowers:
		if flower and flower in initial_flower_positions:
			flower.global_position = initial_flower_positions[flower]
			flower.rotation = Vector3.ZERO

func update_buttons():
	tutorial_btn.disabled = !GameProgress.is_level_available("tutorial")
	level1_btn.disabled = !GameProgress.is_level_available("level1")
	level2_btn.disabled = !GameProgress.is_level_available("level2")
	
	for level_id in GameProgress.levels:
		var button: Button
		match level_id:
			"tutorial": button = tutorial_btn
			"level1": button = level1_btn
			"level2": button = level2_btn
		
		if button:
			var level_data = GameProgress.levels[level_id]
			if level_data.completed:
				button.add_theme_color_override("font_color", Color.GREEN)
				button.add_theme_color_override("font_hover_color", Color(0, 0.7, 0, 1))
				button.add_theme_color_override("font_pressed_color", Color(0, 0.5, 0, 1))
			else:
				button.remove_theme_color_override("font_color")
				button.remove_theme_color_override("font_hover_color")
				button.remove_theme_color_override("font_pressed_color")

func load_level(level_id: String):
	if GameProgress.is_level_available(level_id):
		var level_data = GameProgress.levels[level_id]
		player.teleport(level_data.position)
		load_menu.visible = false
		main_menu.visible = true
		main_menu.toggle_menu()
		var keypad = get_node("/root/main/Map/Room2/Keypad")
		if keypad:
			keypad.reset_keypad_state()

func _on_tutorial_pressed():
	hub.visible = true
	start.visible = true
	hints.visible = false
	player.cancel_win()
	load_level("tutorial")

func _on_level1_pressed():
	reset_flowers()
	hub.visible = false
	start.visible = false
	hints.visible = true
	wall.activate_environment()
	player.cancel_win()
	load_level("level1")

func _on_level2_pressed():
	hub.visible = false
	wall.deactivate_environment()
	player.cancel_win()
	load_level("level2")

func _on_back_pressed():
	load_menu.visible = false
	main_menu.visible = true

func _on_load_pressed():
	print("load pressed")
	main_menu.visible = false
	load_menu.visible = true
	update_buttons()
