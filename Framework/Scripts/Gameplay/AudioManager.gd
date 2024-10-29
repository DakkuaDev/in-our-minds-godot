extends Node

@export var music_library = {}
@export var fade_duration := 1.0 

var current_music: AudioStreamPlayer
var target_volume: float = 1.0 
var fade_direction: float = 0.0 


func _ready():
	current_music = AudioStreamPlayer.new()
	add_child(current_music)
	current_music.volume_db = -80 
	
func _process(delta: float):
	if fade_direction != 0:
		var step = (80 / fade_duration) * delta * fade_direction
		current_music.volume_db += step
		
		if (fade_direction == 1 and current_music.volume_db >= target_volume) or (fade_direction == -1 and current_music.volume_db <= target_volume):
			current_music.volume_db = target_volume
			
			if fade_direction == -1:
				current_music.stop() # Detiene la música después de un fade-out
				
			fade_direction = 0 # Resetea la dirección para detener el fade


func play_music(music_id: StringName, loop: bool = true, fade_in: bool = false, fade_out: bool = false, fade_duration: float = 1.0):
	if not music_library.has(music_id):
		print("Música no encontrada en la biblioteca.")
		return

	current_music.stream = music_library[music_id]
	#current_music.loop = loop
	current_music.play()

	if fade_in:
		current_music.volume_db = -80 
		target_volume = 0 
		self.fade_duration = fade_duration
		fade_direction = 1 
	else:
		current_music.volume_db = 0 

func stop_music(fade_out: bool = false, fade_duration: float = 1.0):
	if fade_out:
		target_volume = -80 
		self.fade_duration = fade_duration
		fade_direction = -1 
	else:
		current_music.stop()
