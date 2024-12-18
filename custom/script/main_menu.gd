extends VBoxContainer
@onready var save: Button = $Save
@onready var start: Button = $Start
@onready var loadBtn: Button = $Load
@onready var settings: Button = $Settings
@onready var player: XROrigin3D = get_node("/root/main/Player")
@onready var menu:  = get_node("/root/main/Player/Menu")
@onready var hub:  = get_node("/root/main/Map/Hub")

func _ready():
	save.visible = false
	save.pressed.connect(_on_save_pressed)
	start.pressed.connect(_on_start_pressed)
	loadBtn.pressed.connect(_on_load_pressed)
	settings.pressed.connect(_on_settings_pressed)

func toggle_menu():
	player.menu_visible = not player.menu_visible
	menu.visible = player.menu_visible
	menu.enabled = player.menu_visible

func _on_save_pressed():
	print("Save button pressed!")
	self.visible = false
	#confirmation.visible = true

func _on_start_pressed():
	print("Start button pressed!")
	hub.visible = false
	player.teleport(Vector3(5, 2, 5))
	start.visible = false
	save.visible = true
	toggle_menu()

func _on_load_pressed():
	print("Load button pressed!")
	self.visible = true
	#confirmation.visible = false

func _on_settings_pressed():
	print("Settings button pressed!")
