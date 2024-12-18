extends AudioStreamPlayer3D

var ambiance1: AudioStream = preload("res://custom/audio/sea-and-seagull-wave-5932.mp3")
var ambiance2: AudioStream = preload("res://custom/audio/spaceship-ambient-27988.mp3")
var sound_on: AudioStream = preload("res://custom/audio/tvon-108126.mp3")
var sound_off: AudioStream = preload("res://custom/audio/machine-powering-down-84722_X83heals.mp3")
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
		self.max_distance = 20  
		self.attenuation_model = ATTENUATION_INVERSE_DISTANCE  
		self.area_mask = 1  
		self.play()
		print("Initial ambiance started")

func play_sound(sound: AudioStream):
	var current_volume = self.volume_db
	self.stream = sound
	self.stream.loop = false
	self.volume_db = 0
	self.play()
	await self.finished
	self.volume_db = current_volume

func switch_to_sea_ambiance():
	print("Switching to sea ambiance...")
	# Jouer le son ON d'abord
	await play_sound(sound_on)
	
	# Fondu sortant pour l'ambiance actuelle
	var fade_out = create_tween()
	fade_out.tween_property(self, "volume_db", -80, 0)
	await fade_out.finished
	
	# Changer vers l'ambiance mer
	self.stream = ambiance1
	self.stream.loop = true
	
	# Fondu entrant
	var fade_in = create_tween()
	fade_in.tween_property(self, "volume_db", -10, 0)
	self.play()
	print("Switched to sea ambiance")

func switch_to_space_ambiance():
	print("Switching to space ambiance...")
	# Jouer le son OFF d'abord
	await play_sound(sound_off)
	
	# Fondu sortant pour l'ambiance actuelle
	var fade_out = create_tween()
	fade_out.tween_property(self, "volume_db", -80, 0)
	await fade_out.finished
	
	# Changer vers l'ambiance espace
	self.stream = ambiance2
	self.stream.loop = true
	
	# Fondu entrant
	var fade_in = create_tween()
	fade_in.tween_property(self, "volume_db", -10, 0)
	self.play()
	print("Switched to space ambiance")

func stop_ambiance():
	var fade_out = create_tween()
	fade_out.tween_property(self, "volume_db", -80, 0)
	await fade_out.finished
	await play_sound(sound_off)
	self.stop()
	print("Ambiance stopped")
