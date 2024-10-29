# @description: UI control script for scene selection and timed button display. Plays background music and manages game start/reset.
# @author: Daniel Guerra Gallardo. (@DakkuaDev)
# @date: 10/2024

extends Control

# Exposed variables for scene configuration
@export var scene: String # Target scene to load when starting the game.
@export var first_scene: bool = false # Indicates if this is the first scene of the game.
@export var timer_time: float = 2.5 # Duration (in seconds) before start button becomes visible.
@export var music_to_play : String = "" # Background music to play, if set.

# Node references
@onready var btn_start : Button = $Panel/VBoxContainer/BtnStart # Start button reference.
@onready var timer : Timer = $Timer # Timer to control the delayed appearance of the start button.
@onready var lbl_title : Label = $Panel/VBoxContainer/LblTitle # Title label in the UI.

# Initializes UI and music on ready
func _ready():
	# Play background music if specified
	if music_to_play != "":
		AudioManager.play_music(music_to_play, true, true, true, 2.0) # Plays music with looping and fade-in.
	
	timer.start(timer_time) # Start timer to delay start button visibility.
	btn_start.visible = false # Hide start button initially.
	
	pass

# Handles start button click, initiating the game scene.
func _on_btn_start_button_down() -> void:
	GameManager._start_game(scene) # Start the game and load the specified scene.
	
	pass

# Handles exit button click, resetting the game to main menu.
func _on_btn_exit_button_down() -> void:
	GameManager._reset_game() # Resets game, typically to the main menu.
	
	pass 

# Timer timeout callback to show the start button after delay.
func _on_timer_timeout() -> void:
	timer.stop() # Stops the timer to prevent further triggers.
	btn_start.visible = true # Make start button visible for user interaction.
	
	pass
