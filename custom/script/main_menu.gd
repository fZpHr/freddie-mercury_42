extends VBoxContainer
@onready var start: Button = $Start
@onready var player: XROrigin3D = get_node("/root/main/Player")
@onready var menu:  = get_node("/root/main/Player/Menu")
@onready var hub:  = get_node("/root/main/Map/Hub")

func _ready():
	start.pressed.connect(_on_start_pressed)

func toggle_menu():
	player.menu_visible = not player.menu_visible
	menu.visible = player.menu_visible
	menu.enabled = player.menu_visible

func _on_start_pressed():
	hub.visible = false
	player.teleport(Vector3(5, 2, 5))
	start.visible = false
	toggle_menu()
	GameProgress.reset_progress()
	GameProgress.complete_level("tutorial")
