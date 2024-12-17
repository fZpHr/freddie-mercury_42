extends AudioStreamPlayer3D

var ambiance1: AudioStream = preload("res://models/sea-and-seagull-wave-5932.mp3")
var ambiance2: AudioStream = preload("res://models/spaceship-ambient-27988.mp3")
var sound_on: AudioStream = preload("res://models/tvon-108126.mp3")
var sound_off: AudioStream = preload("res://models/machine-powering-down-84722.mp3")

func _ready():
	setup_initial_ambiance()

func setup_initial_ambiance():
	if ambiance1:
		print("Starting initial ambiance...")
		self.stream = ambiance1
		self.stream.loop = true
		self.unit_size = 50  
		self.max_db = 0  
		self.volume_db = -10  
		self.max_distance = 50  
		self.attenuation_model = ATTENUATION_INVERSE_DISTANCE  
		self.area_mask = 1  
		self.play()
		print("Initial ambiance started")

func play_transition_sound(sound: AudioStream):
	# Sauvegarde l'ambiance actuelle
	var current_ambiance = self.stream
	var current_volume = self.volume_db
	
	# Joue le son de transition
	self.stream = sound
	self.stream.loop = false
	self.volume_db = 0
	self.play()
	await self.finished
	
	# Restaure l'ambiance
	self.stream = current_ambiance
	self.volume_db = current_volume
	if current_ambiance:
		self.play()

func change_ambiance(new_ambiance: AudioStream):
	if not new_ambiance:
		print("New ambiance stream not found")
		return
		
	print("Starting ambiance transition...")
	
	# Joue le son off
	await play_transition_sound(sound_off)
	
	# Fondu sortant
	var fade_out = create_tween()
	fade_out.tween_property(self, "volume_db", -80, 1.0)
	await fade_out.finished
	
	# Change l'ambiance
	self.stream = new_ambiance
	self.stream.loop = true
	
	# Joue le son on
	await play_transition_sound(sound_on)
	
	# Fondu entrant
	var fade_in = create_tween()
	fade_in.tween_property(self, "volume_db", -10, 1.0)
	print("Ambiance transition completed")
	self.play()

func switch_to_sea_ambiance():
	change_ambiance(ambiance1)

func switch_to_space_ambiance():
	change_ambiance(ambiance2)

func stop_ambiance():
	var fade_out = create_tween()
	fade_out.tween_property(self, "volume_db", -80, 1.0)
	await fade_out.finished
	await play_transition_sound(sound_off)
	self.stop()
	print("Ambiance stopped")
