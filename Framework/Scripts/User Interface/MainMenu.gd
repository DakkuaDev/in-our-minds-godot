# @description: Main Menu script to handle user interactions, including starting the game, accessing options, and navigating to external links.
# @author: Daniel Guerra Gallardo. (@DakkuaDev)
# @date: 10/2024

extends Control 

# Node references for buttons and panels
@onready var btn_start: Button = $Panel/VBoxContainer/BtnStart  # Button to start the game.
@onready var btn_exit: Button = $Panel/VBoxContainer/BtnExit  # Button to exit the game.
@onready var btn_options: Button = $Panel/VBoxContainer/BtnOptions  # Button to open options menu.

@onready var debug_next_level: TextEdit = $Panel/DebugTextEdit  # Text input for debug level selection.
@onready var on_debug_mode: bool = false  # Flag to check if debug mode is active.

@onready var optionsMenu: Control = $Panel/OptionsMenu  # Options menu panel reference.
@onready var about_panel = $Panel/AboutPanel  # About panel reference.
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer  # Audio player for button sounds.

# Initializes the menu and plays background music.
func _ready():
	# @description: Plays the main theme music when the menu is ready.
	AudioManager.play_music("music_theme_01", true, true, true, 2.0)

# Processes user input for debug mode and other actions.
func _process(delta):
	# @description: Checks for user input to toggle debug mode and exit about panel.
	if Input.is_action_just_pressed("DEBUG_MODE"):
		debug_next_level.visible = true  # Show debug level input.
		on_debug_mode = true  # Set debug mode flag to true.
		
	if Input.is_action_just_pressed("exit"):
		about_panel.visible = false  # Hide about panel on exit command.
		
	pass

# Starts the game when the start button is pressed.
func _on_btn_start_button_down() -> void:
	# @description: Handles start button press and begins the game.
	_on_play_button_sound()  # Play button sound.
	
	if on_debug_mode:  # Check if debug mode is active.
		GameManager._start_game(debug_next_level.text)  # Start game with debug level.
	else:
		GameManager._on_show_chapter_menu()  # Show chapter menu.

	pass

# Opens the options menu when the options button is pressed.
func _on_btn_options_button_down() -> void:
	# @description: Displays the options menu when the options button is clicked.
	_on_play_button_sound()  # Play button sound.
	
	optionsMenu.visible = true  # Make options menu visible.
	
	pass
	
# Exits the game when the exit button is pressed.
func _on_btn_exit_button_down() -> void:
	# @description: Calls the game manager to exit the game.
	_on_play_button_sound()  # Play button sound.
	
	GameManager._exit_game()  # Exit the game.
	
	pass
	
# Opens the GitHub repository link when the GitHub button is pressed.
func _on_btn_github_button_down() -> void:
	# @description: Opens the GitHub repository in the default web browser.
	_on_play_button_sound()  # Play button sound.
	
	OS.shell_open("https://github.com/DakkuaDev/in-our-minds-godot")  # Open GitHub repo.
	
	pass
	
# Displays the about panel when the about button is pressed.
func _on_btn_about_button_down() -> void:
	# @description: Shows the about panel with information about the game.
	_on_play_button_sound()  # Play button sound.
	
	about_panel.visible = true  # Make about panel visible.
	
	pass 

# Plays a sound effect for button presses with a randomized pitch.
func _on_play_button_sound() -> void:
	# @description: Plays the button press sound with a random pitch scale for variability.
	var rng = RandomNumberGenerator.new()  # Create a new random number generator.
	
	audio_stream_player.pitch_scale = rng.randf_range(1, 2.5)  # Set random pitch between 1 and 2.5.
	audio_stream_player.play()  # Play the sound effect.
