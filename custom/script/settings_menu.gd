extends Button
@onready var main_menu: VBoxContainer = $".."
@onready var settings: VBoxContainer = $"../../Settings"
@onready var english_btn: Button = $"../../Language/English"
@onready var french_btn: Button = $"../../Language/French"
@onready var spanish_btn: Button = $"../../Language/Spanish"
@onready var back_btn: Button = $"../../Language/Back"
@onready var music_btn: Button = $"../../Settings/Music"

func _ready():
	self.pressed.connect(_on_settings_pressed)
	english_btn.pressed.connect(_on_english_pressed)
	french_btn.pressed.connect(_on_french_pressed)
	spanish_btn.pressed.connect(_on_spanish_pressed)
	back_btn.pressed.connect(_on_back_pressed)
	music_btn.pressed.connect(_on_music_pressed)
	main_menu.visible = false

func _on_settings_pressed():
	settings.visible = true
	main_menu.visible = false

func _on_english_pressed():
	TranslationServer.set_locale("en")
	_go_back()

func _on_french_pressed():
	TranslationServer.set_locale("fr")
	_go_back()

func _on_spanish_pressed():
	TranslationServer.set_locale("es")
	_go_back()

func _on_back_pressed():
	_go_back()

func _go_back():
	settings.visible = false
	main_menu.visible = true

func _on_music_pressed():
	if AudioServer.is_bus_mute(0):
		AudioServer.set_bus_mute(0, false)
		music_btn.text = "Music: On"
	else:
		AudioServer.set_bus_mute(0, true)
		music_btn.text = "Music: Off"
