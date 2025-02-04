extends Node

const TRANS_EN = preload("res://custom/translations/translations.en.translation")
const TRANS_ES = preload("res://custom/translations/translations.es.translation")
const TRANS_FR = preload("res://custom/translations/translations.fr.translation")

func load_translations() -> void:
	TranslationServer.add_translation(TRANS_EN)
	TranslationServer.add_translation(TRANS_ES)
	TranslationServer.add_translation(TRANS_FR)

func _ready() -> void:
	load_translations()
	TranslationServer.set_locale("en")
