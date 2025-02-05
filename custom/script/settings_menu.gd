extends Button

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

@onready var start: Button = $"../Start"
@onready var hints: Button = $"../Hints"
@onready var load: Button = $"../Load"
@onready var settings_btn: Button = $"."
@onready var quit: Button = $"../Quit"
@onready var label: Label = $"../../Confirmation/Label"
@onready var yes: Button = $"../../Confirmation/Yes"
@onready var no: Button = $"../../Confirmation/No"
@onready var music: Button = $"../../Settings/Music"
@onready var back: Button = $"../../Settings/Back"
@onready var french: Button = $"../../Language/French"
@onready var english: Button = $"../../Language/English"
@onready var spanish: Button = $"../../Language/Spanish"
@onready var back1: Button = $"../../Language/Back"
@onready var tutorial: Button = $"../../Load/Tutorial"
@onready var level_1: Button = $"../../Load/Level 1"
@onready var level_2: Button = $"../../Load/Level 2"
@onready var back2: Button = $"../../Load/Back"
@onready var new_hint: Button = $"../../Hints/New Hint"
@onready var previous_hints: Button = $"../../Hints/Previous Hints"
@onready var back3: Button = $"../../Hints/Back"

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
	TranslationServer.set_locale(GameProgress.get_language())
	_update_texts()

func _on_language_pressed():
	settings.visible = false
	language_menu.visible = true

func _on_settings_pressed():
	_update_music_btn()
	settings.visible = true
	main_menu.visible = false

func _on_english_pressed():
	TranslationServer.set_locale("en")
	GameProgress.save_language("en")
	_update_texts()
	_go_back()

func _on_french_pressed():
	TranslationServer.set_locale("fr")
	GameProgress.save_language("fr")
	_update_texts()
	_go_back()

func _on_spanish_pressed():
	TranslationServer.set_locale("es")
	GameProgress.save_language("es")
	_update_texts()
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

func _update_texts():
	start.text = tr("BTN_START")
	hints.text = tr("BTN_HINTS")
	load.text = tr("BTN_LOAD")
	settings_btn.text = tr("BTN_SETTINGS")
	quit.text = tr("BTN_QUIT")
	label.text = tr("CONFIRM_QUIT")
	yes.text = tr("BTN_YES")
	no.text = tr("BTN_NO")
	back.text = tr("BTN_BACK")
	french.text = tr("LANG_FRENCH")
	english.text = tr("LANG_ENGLISH")
	spanish.text = tr("LANG_SPANISH")
	back1.text = tr("BTN_BACK")
	tutorial.text = tr("MENU_TUTORIAL")
	level_1.text = tr("MENU_LEVEL1")
	level_2.text = tr("MENU_LEVEL2")
	back2.text = tr("BTN_BACK")
	new_hint.text = tr("BTN_NEW_HINT")
	previous_hints.text = tr("BTN_PREV_HINT")
	back3.text = tr("BTN_BACK")
	language_btn.text = tr("LABEL_LANGUAGE")
	_update_music_btn()
