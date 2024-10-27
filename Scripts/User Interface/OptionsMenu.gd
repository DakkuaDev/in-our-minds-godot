extends Control

@onready var masterBus = AudioServer.get_bus_index("Master")
@onready var sfxBus = AudioServer.get_bus_index("SFX")
@onready var musicBus = AudioServer.get_bus_index("Music")

@onready var flag_sprite_2d = $Panel/Panel/VBoxContainer/LangugageSelectionContainer/FlagSprite2D
@onready var audio_stream_player = $AudioStreamPlayer

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		self.visible = false
		
	pass

func _on_option_button_item_selected(index):
		match index:
			0: 
				TranslationServer.set_locale("en")
				flag_sprite_2d.texture = preload("res://Textures/User Interface/en-flag.png")
				
			1: 
				TranslationServer.set_locale("es") 
				flag_sprite_2d.texture = preload("res://Textures/User Interface/es-flag.png")	
		pass 

func _on_full_screen_mode_toggled(toggled_on):
	_on_fullscreen()
	
	pass 
	
func _on_fullscreen() -> void:
		if(GameManager.full_screen_mode):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			#popup_menu.set_item_checked(FULL_SCREEN_INDEX, false)
			GameManager.full_screen_mode = false
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			#popup_menu.set_item_checked(FULL_SCREEN_INDEX, true)
			GameManager.full_screen_mode = true
		pass

func _on_master_slider_value_changed(value) -> void:
	AudioServer.set_bus_volume_db(masterBus, linear_to_db(value))
	AudioServer.set_bus_mute(masterBus, value < 0.15)
	
	pass


func _on_music_slider_value_changed(value) -> void:
	AudioServer.set_bus_volume_db(musicBus, linear_to_db(value))
	AudioServer.set_bus_mute(musicBus, value < 0.15)
	
	pass 

func _on_sfx_slider_value_changed(value) -> void:
	AudioServer.set_bus_volume_db(sfxBus, linear_to_db(value))
	AudioServer.set_bus_mute(sfxBus, value < 0.15)
	audio_stream_player.play()
	
	
	pass 
