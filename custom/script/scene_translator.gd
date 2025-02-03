extends Node

@onready var shrinesHint: Label = $"../Room2/Stand/Sprite3D/SubViewport/Label"
@onready var seasonsHint: Label = $"../Room1/Walls/Environment/Tree/Sprite3D2/SubViewport/Label"
@onready var climbHint: Label = $"../Room1/Walls/Environment/Tree/Sprite3D/SubViewport/Label"

@onready var tutoLabel1: Label3D = $"../Hub/Labels/Label3D"
@onready var tutoLabel2: Label3D = $"../Hub/Labels/Label3D2"
@onready var tutoLabel3: Label3D = $"../Hub/Labels/Label3D4"
@onready var tutoLabel4: Label3D = $"../Hub/Labels/Label3D7"
@onready var tutoLabel5: Label3D = $"../Hub/Labels/Label3D8"
@onready var tutoLabel6: Label3D = $"../Hub/Labels/Label3D5"
@onready var tutoLabel7: Label3D = $"../Hub/Labels/Label3D6"

func _ready() -> void:
	update_texts()

func update_texts() -> void:
	shrinesHint.text = tr("SHRINES_HINT")
	seasonsHint.text = tr("SEASONS_HINT")
	climbHint.text = tr("CLIMB_HINT")
	
	tutoLabel1.text = tr("TUTO_WELCOME")
	tutoLabel2.text = tr("TUTO_START")
	tutoLabel3.text = tr("TUTO_GRAB")
	tutoLabel4.text = tr("TUTO_MENU")
	tutoLabel5.text = tr("TUTO_START_BUTTON")
	tutoLabel6.text = tr("TUTO_CROUCH")
	tutoLabel7.text = tr("TUTO_JUMP")

func change_language(locale: String) -> void:
	TranslationServer.set_locale(locale)
	update_texts()
