extends Node3D

@export var correct_password = "12345"
@onready var door = get_node("../Door")
var is_audio_playing = false
var password = ""
var door_already_opened = false

signal on_correct_password
signal on_wrong_password
signal on_clear_password
signal on_keypad_press

# Audio nodes
var pressed_audio: AudioStreamPlayer3D
var correct_audio: AudioStreamPlayer3D
var wrong_audio: AudioStreamPlayer3D
var door_open: AudioStreamPlayer3D

# UI nodes
var keys: Node3D
var password_label: Label
var xr_interface: XRInterface

func _ready():
	print("Keypad script starting...")
	# Get audio nodes
	pressed_audio = $PressedAudioStream
	correct_audio = $CorrectAudioStream
	wrong_audio = $WrongAudioStream
	door_open = $"Heavy-pressurased-door"
	print("Audio nodes loaded:", pressed_audio, correct_audio, wrong_audio)
	
	# Get UI nodes
	keys = $Keys
	password_label = $SubViewport/PasswordViewport/PasswordLabel
	print("UI nodes loaded - Keys:", keys, " Label:", password_label)
	
	# Setup VR interface
	xr_interface = XRServer.find_interface("OpenXR")
	print("VR Interface loaded:", xr_interface)
	
	# Connect signals from buttons
	for child in keys.get_children():
		print("Checking child:", child)
		if child is StaticBody3D:
			print("Tentative de connexion pour la touche")
			child.input_ray_pickable = true
			child.connect("on_interact", on_button_interact)
			print("Connected signal for:", child)
	
	# Clear initial password display
	password_label.text = ""
	print("Initial setup complete")

func on_button_interact(value):
	print("\nButton pressed with value:", value)
	print("Current password before:", password)
	
	if is_audio_playing:
		print("Audio still playing, ignoring press")
		return
		
	# Play button press audio
	is_audio_playing = true
	pressed_audio.playing = true
	print("Playing press sound")
	
	# Handle different button types
	if value == ".": # Enter key
		print("Enter pressed with password:", password)
		if password == correct_password and not door_already_opened:
			print("Password correct!")
			correct_audio.play()
			emit_signal("on_correct_password", password)
			trigger_success_feedback()
		else:
			print("Password incorrect or door already opened!")
			wrong_audio.play()
			emit_signal("on_wrong_password", password)
			trigger_error_feedback()
		password = ""
		
	elif value == "C": # Clear key
		print("Clear pressed")
		emit_signal("on_clear_password", password)
		password = ""
		trigger_clear_feedback()
		
	else: # Number key
		if password.length() < correct_password.length():
			password += value
			print("Added digit:", value, "New password:", password)
			emit_signal("on_keypad_press", password)
			
	password_label.text = password
	print("Password label updated to:", password_label.text)

func _on_AudioStreamPlayer3D_finished():
	is_audio_playing = false

func trigger_success_feedback():
	if not door_already_opened:
		door_already_opened = true
		GameProgress.complete_level("level2")
		var anim_player = door.get_node("AnimationPlayer")
		print("Chemin de la porte:", door.get_path())
		
		var static_body = door.get_node("StaticBody3D")
		if static_body:
			var collision_shape = static_body.get_node("CollisionShape3D")
			if collision_shape:
				collision_shape.set_deferred("disabled", true)
				static_body.collision_layer = 0 
				static_body.collision_mask = 0
				print("Collision désactivée de plusieurs façons")
			
		if anim_player:
			anim_player.play("door_open")
			if door_open:
				door_open.play()
			print("Animation lancée")
	else:
		print("Door already open")

	if xr_interface and xr_interface.is_initialized():
		xr_interface.trigger_haptic_pulse("default_action_set", "default_haptic", 0.1, 65.0, 0.0, 1.0)
		
func trigger_error_feedback():
	if xr_interface and xr_interface.is_initialized():
		xr_interface.trigger_haptic_pulse("default_action_set", "default_haptic", 0.1, 65.0, 0.0, 0.7)
		await get_tree().create_timer(0.1).timeout
		xr_interface.trigger_haptic_pulse("default_action_set", "default_haptic", 0.1, 65.0, 0.0, 0.7)

func trigger_clear_feedback():
	if xr_interface and xr_interface.is_initialized():
		xr_interface.trigger_haptic_pulse("default_action_set", "default_haptic", 0.1, 65.0, 0.0, 0.3)
