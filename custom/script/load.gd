extends Button
@onready var main_menu: VBoxContainer = $".."
@onready var load_menu: VBoxContainer = $"../Load"
@onready var tutorial_btn: Button = $"../../Load/Tutorial"
@onready var level1_btn: Button = $"../../Load/Level 1"
@onready var level2_btn: Button = $"../../Load/Level 2"
@onready var back_btn: Button = $"../../Load/Back"
@onready var player: XROrigin3D = get_node("/root/main/Player")

func _ready():
	self.pressed.connect(_on_load_pressed)
	tutorial_btn.pressed.connect(_on_tutorial_pressed)
	level1_btn.pressed.connect(_on_level1_pressed)
	level2_btn.pressed.connect(_on_level2_pressed)
	back_btn.pressed.connect(_on_back_pressed)
	update_buttons()

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
			var status_text = " (Completed)" if level_data.completed else ""
			button.text = level_data.name + status_text

func load_level(level_id: String):
	if GameProgress.is_level_available(level_id):
		var level_data = GameProgress.levels[level_id]
		player.teleport(level_data.position)
		load_menu.visible = false
		main_menu.visible = true
		main_menu.toggle_menu()

func _on_tutorial_pressed():
	load_level("tutorial")

func _on_level1_pressed():
	load_level("level1")

func _on_level2_pressed():
	load_level("level2")

func _on_back_pressed():
	load_menu.visible = false
	main_menu.visible = true

func _on_load_pressed():
	main_menu.visible = false
	load_menu.visible = true
	load_menu.update
