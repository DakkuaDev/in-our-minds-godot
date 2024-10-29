# @description: Audio Manager for managing background music with fade-in and fade-out effects.
# @author: Daniel Guerra Gallardo. (@DakkuaDev)
# @date: 10/2024

extends Node

# Exposed variables
@export var music_library = {} # Dictionary storing available music tracks, with keys as identifiers.
@export var fade_duration := 1.0 # Duration in seconds for fade-in and fade-out effects.

# Internal variables
var current_music: AudioStreamPlayer # Current music player instance.
var target_volume: float = 1.0 # Target volume for fade effects, set between -80 (silent) and 0 (max).
var fade_direction: float = 0.0 # Controls fade direction: 1 for fade-in, -1 for fade-out.

# Called when the node is added to the scene.
func _ready():
	# Initializes and adds the audio player to the scene. Sets initial volume to -80 dB (silent).
	current_music = AudioStreamPlayer.new()
	add_child(current_music)
	current_music.volume_db = -80

# Called every frame, updates fade effect based on delta time.
func _process(delta: float):
	if fade_direction != 0:
		# Calculates fade step based on fade duration and direction.
		var step = (80 / fade_duration) * delta * fade_direction
		current_music.volume_db += step
		
		# Checks if fade has reached the target volume, stops or resets fade as needed.
		if (fade_direction == 1 and current_music.volume_db >= target_volume) or (fade_direction == -1 and current_music.volume_db <= target_volume):
			current_music.volume_db = target_volume
			
			# Stops music if fade-out completed.
			if fade_direction == -1:
				current_music.stop()
				
			# Resets fade direction to stop fade updates.
			fade_direction = 0

# Plays specified music track with optional fade-in, looping, and fade-out.
# @param music_id: StringName - Identifier of the music in the library.
# @param loop: bool - Whether to loop the track (default: true).
# @param fade_in: bool - Whether to apply a fade-in effect (default: false).
# @param fade_out: bool - Placeholder, fade-out option not implemented here.
# @param fade_duration: float - Duration of fade-in effect if enabled.
func play_music(music_id: StringName, loop: bool = true, fade_in: bool = false, fade_out: bool = false, fade_duration: float = 1.0):
	# Verifies music is in library, prints error if not found.
	if not music_library.has(music_id):
		print("Music not found in library.")
		return

	# Sets audio stream and starts playback with optional loop and fade-in settings.
	current_music.stream = music_library[music_id]
	# current_music.loop = loop
	current_music.play()

	# Configures fade-in if enabled; otherwise sets full volume.
	if fade_in:
		current_music.volume_db = -80
		target_volume = 0
		self.fade_duration = fade_duration
		fade_direction = 1
	else:
		current_music.volume_db = 0

# Stops the current music with an optional fade-out effect.
# @param fade_out: bool - Whether to apply a fade-out effect (default: false).
# @param fade_duration: float - Duration of fade-out effect if enabled.
func stop_music(fade_out: bool = false, fade_duration: float = 1.0):
	# Configures fade-out if enabled; otherwise stops music immediately.
	if fade_out:
		target_volume = -80
		self.fade_duration = fade_duration
		fade_direction = -1
	else:
		current_music.stop()
