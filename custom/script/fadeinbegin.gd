extends Node3D

@onready var audio_player = AudioStreamPlayer3D.new()
var tween: Tween

func _ready():
	add_child(audio_player)
	audio_player.stream = preload("res://custom/audio/ambient-background-loop-234090.mp3")
	audio_player.volume_db = -80  # Commence silencieux

func start_audio_fade():
	# Arrêter le tween précédent s'il existe
	if tween:
		tween.kill()
	
	# Démarrer l'audio
	audio_player.play()
	audio_player.volume_db = -80
	
	# Créer nouveau tween pour le fade
	tween = create_tween()
	tween.tween_property(audio_player, "volume_db", 0, 2.0)  # Fade sur 2 secondes jusqu'au volume normal
