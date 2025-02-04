extends Button

@onready var language_handler: Node = get_node("/root/main/Map/LanguageHandler")
@onready var viewport_2d_in_3d = get_node("/root/main/Map/Viewport2Din3D")

@onready var main_menu: VBoxContainer = $".."
@onready var settings: VBoxContainer = $"../../Settings"
@onready var language_menu: VBoxContainer = $"../../Language"

@onready var english_btn: Button = $"../../Language/English"
@onready var french_btn: Button = $"../../Language/French"
@onready var spanish_btn: Button = $"../../Language/Spanish"
@onready var language_back_btn: Button = $"../../Language/Back"
@onready var back_btn: Button = $"../../Settings/Back"
@onready var music_btn: Button = $"../../Settings/Music"
@onready var language_btn: Button = $"../../Settings/Language"

var music_on: bool = true

func _ready():
	self.pressed.connect(_on_settings_pressed)
	language_btn.pressed.connect(_on_language_pressed)
	english_btn.pressed.connect(_on_english_pressed)
	french_btn.pressed.connect(_on_french_pressed)
	spanish_btn.pressed.connect(_on_spanish_pressed)
	language_back_btn.pressed.connect(_on_back_pressed)
	back_btn.pressed.connect(_on_back_pressed)
	music_btn.pressed.connect(_on_music_pressed)
	_update_music_btn()

func _on_language_pressed():
	settings.visible = false
	language_menu.visible = true

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
	language_menu.visible = false
	settings.visible = false
	main_menu.visible = true

func _on_music_pressed():
	if AudioServer.is_bus_mute(0):
		music_on = true
		AudioServer.set_bus_mute(0, false)
		_update_music_btn()
	else:
		music_on = false
		AudioServer.set_bus_mute(0, true)
		_update_music_btn()

func _update_music_btn():
	if music_on:
		music_btn.text = tr("LABEL_MUSIC") + ": " + tr("LABEL_ON")
	else:
		music_btn.text = tr("LABEL_MUSIC") + ": " + tr("LABEL_OFF")
