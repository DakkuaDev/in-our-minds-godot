# @description: Options Menu script to handle language selection, audio settings, and fullscreen mode toggling.
# @author: Daniel Guerra Gallardo. (@DakkuaDev) y Sandro Alvoz (@sandroalvoz)
# @date: 10/2024

extends Control 

# Exposed variables
@export var language_dict: Dictionary  # Dictionary for storing flag textures for different languages.

# Node references for audio buses
@onready var masterBus = AudioServer.get_bus_index("Master")  # Master audio bus index.
@onready var sfxBus = AudioServer.get_bus_index("SFX")  # Sound effects audio bus index.
@onready var musicBus = AudioServer.get_bus_index("Music")  # Music audio bus index.

# Node references for UI components
@onready var texture_rect_language : TextureRect = $Panel/Panel/VBoxContainer/LangugageSelectionContainer/TextureRectLanguage # UI element for displaying the selected language flag.
@onready var audio_stream_player = $AudioStreamPlayer  # Audio player for playing sound effects.

# Handles input events for the options menu.
func _input(event):
	# @description: Hides the options menu when the cancel action is triggered.
	if event.is_action_pressed("ui_cancel"):
		self.visible = false
		
	pass

# Updates the game language based on the selected option.
func _on_option_button_item_selected(index):
	# @description: Sets the locale based on the selected language index.
	match index:
		0: TranslationServer.set_locale("en")  # Set language to English.
		1: TranslationServer.set_locale("es")  # Set language to Spanish.
		# Add more languages here
	
	texture_rect_language.texture = language_dict[index]  # Updates the displayed flag sprite.

	pass 

# Toggles fullscreen mode based on the user's selection.
func _on_full_screen_mode_toggled(toggled_on):
	# @description: Calls the function to handle fullscreen toggling.
	_on_fullscreen()
	
	pass 
	
# Handles the fullscreen mode logic.
func _on_fullscreen() -> void:
	# @description: Switches between windowed and fullscreen modes.
	if GameManager.full_screen_mode:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)  # Set windowed mode.
		GameManager.full_screen_mode = false  # Update fullscreen mode flag.
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)  # Set fullscreen mode.
		GameManager.full_screen_mode = true  # Update fullscreen mode flag.
		
	pass

# Adjusts the master audio volume based on the slider value.
func _on_master_slider_value_changed(value) -> void:
	# @description: Updates the master audio bus volume and mutes if below a threshold.
	AudioServer.set_bus_volume_db(masterBus, linear_to_db(value))  # Set volume in decibels.
	AudioServer.set_bus_mute(masterBus, value < 0.15)  # Mute if volume is less than 15%.

	pass

# Adjusts the music audio volume based on the slider value.
func _on_music_slider_value_changed(value) -> void:
	# @description: Updates the music audio bus volume and mutes if below a threshold.
	AudioServer.set_bus_volume_db(musicBus, linear_to_db(value))  # Set volume in decibels.
	AudioServer.set_bus_mute(musicBus, value < 0.15)  # Mute if volume is less than 15%.

	pass 

# Adjusts the sound effects audio volume based on the slider value.
func _on_sfx_slider_value_changed(value) -> void:
	# @description: Updates the sound effects audio bus volume, mutes if below a threshold, and plays a sound effect.
	AudioServer.set_bus_volume_db(sfxBus, linear_to_db(value))  # Set volume in decibels.
	AudioServer.set_bus_mute(sfxBus, value < 0.15)  # Mute if volume is less than 15%.
	audio_stream_player.play()  # Play the sound effect.

	pass 


func _on_button_button_down():
	self.visible = false
	
	pass 
