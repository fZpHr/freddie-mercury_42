extends AudioStreamPlayer3D

var ambiance1: AudioStream = preload("res://custom/audio/computer-processing-sound-effect-01-122131.mp3")

func _ready():
	setup_initial_ambiance()

func setup_initial_ambiance():
	if ambiance1:
		self.stream = ambiance1
		self.stream.loop = true
		self.unit_size = 50  
		self.max_db = 0  
		self.volume_db = -10 
		self.max_distance = 10  
		self.attenuation_model = ATTENUATION_INVERSE_DISTANCE  
		self.area_mask = 1  
		self.play()
