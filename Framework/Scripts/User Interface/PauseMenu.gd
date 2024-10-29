# @description: Pause Menu script to manage game pausing, options menu visibility, and transitions back to the main menu.
# @author: Daniel Guerra Gallardo. (@DakkuaDev)
# @date: 10/2024

extends Control 

# Node references
@onready var options_menu = $Panel/OptionsMenu  # Reference to the options menu UI element.

# Initializes the pause menu visibility.
func _ready():
	# @description: Sets the pause menu to be invisible when ready.
	visible = false
	
	pass

# Processes input events each frame.
func _process(delta):
	# @description: Checks for the exit action to hide the options menu.
	if Input.is_action_just_pressed("exit"):
		options_menu.visible = false  # Hide the options menu when "exit" is pressed.
		
	pass
	
# Resets the pause menu visibility and unfreezes the game.
func _reset() -> void:
	# @description: Resets the pause menu state and resumes the game.
	visible = false  # Hide the pause menu.
	GameManager._freeze_game(false)  # Unfreeze the game state.
	
	pass

# Continues the game by resetting the pause menu.
func _on_btn_continue_button_down() -> void:
	# @description: Handles the continue button click to resume the game.
	_reset()  # Call the reset function to hide the pause menu.
	
	pass

# Returns to the main menu and resets the game state.
func _on_btn_main_menu_button_down() -> void:
	# @description: Handles the main menu button click, resets the game, and hides the pause menu.
	_reset()  # Reset the pause menu state.
	GameManager._reset_game()  # Reset the game to main menu state.
	
	pass

# Opens the options menu (currently a work in progress).
func _on_btn_options_button_down() -> void: 
	# @description: Displays the options menu. (WIP - do not use yet)
	options_menu.visible = true  # Show the options menu when the button is pressed.
	
	pass 
