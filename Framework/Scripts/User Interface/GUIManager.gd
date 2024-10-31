# @description: UI Manager script to control the game interface, including the chronometer, collectibles, and stamina progress bar.
# @author: Daniel Guerra Gallardo. (@DakkuaDev)
# @date: 10/2024

extends Control 

# Exposed variables
@export var chrono: Node  # Reference to the chronometer node.
@export var collectible_base_url: String = "https://entiendetumente.info/"  # Base URL for collectible resources.

# Node references
@onready var panel_container: PanelContainer = $PanelContainer  # Panel container for the UI elements.
@onready var level_label: Label = $PanelContainer/VBoxContainer/LevelLabel  # Label to display the current level.
@onready var description_label: Label = $PanelContainer/DescriptionLabel  # Label to show descriptions.
@onready var stamina_progress_bar: TextureProgressBar = $PanelContainer/StaminaProgressBar  # Progress bar for stamina management.
@onready var background_panel_description = $BackgroundPanelDescription


var url = ""  # URL for the collectible to be opened.

# Initializes the UI and connects to scene change events.
func _ready():
	# @description: Connects scene change signal to update game manager.
	SceneManager.scene_changed.connect(GameManager._on_scene_changed)
	
	pass
	
# Resets the GUI to its initial state.
func _reset_gui() -> void:
	# @description: Displays the GUI and resets its components.
	_show_gui(true)  # Show the main UI.
	_on_show_description("", false)  # Hide the description label.
	_on_show_collectible("", false)  # Hide the collectible indication.
	_on_set_chrono(true)  # Start the chronometer.
	_reset_stamina_progress_bar()  # Reset the stamina progress bar.
	
	pass
	
# Stops the GUI and hides all elements.
func _stop_gui() -> void:
	# @description: Hides the GUI and resets its components.
	_show_gui(false)  # Hide the main UI.
	_on_show_description("", false)  # Hide the description label.
	_on_show_collectible("", false)  # Hide the collectible indication.
	_on_set_chrono(false)  # Stop the chronometer.
	_reset_stamina_progress_bar()  # Reset the stamina progress bar.
	
	pass
	
# Shows or hides the main panel.
func _show_gui(state: bool) -> void:
	# @param state: bool - True to show the GUI, false to hide it.
	panel_container.visible = state
	
	pass

# Displays the description message.
func _on_show_description(messg: String, state: bool) -> void:
	# @param messg: String - The message to display in the description label.
	# @param state: bool - True to show the description label, false to hide it.
	description_label.visible = state  # Set the visibility of the description label.
	description_label.text = messg  # Update the text of the description label.
	background_panel_description.visible = state
	
	pass
	
# Shows the collectible item and opens its URL.
func _on_show_collectible(endpoint: String, state: bool) -> void:
	# @param endpoint: String - The endpoint to be added to the base URL.
	# @param state: bool - True to show the collectible, false to hide it.
	if (state): 
		url = collectible_base_url + endpoint  # Construct the full URL.
		OS.shell_open(url)  # Open the URL in the default browser.
		GameManager._freeze_game(true)  # Freeze the game state.
		PauseMenu.visible = true  # Show the pause menu.
	
	pass
	
# Sets the state of the chronometer.
func _on_set_chrono(state: bool) -> void:
	# @param state: bool - True to start the chronometer, false to stop it.
	chrono.on_chrono = state  # Update the state of the chronometer.
	chrono.reset_chrono()  # Reset the chronometer to zero.
	
	pass
	
# Consumes stamina from the progress bar.
# @return: bool - True if stamina was consumed, false if stamina is at minimum.
func _consume_stamina_progress_bar() -> bool:
	if (stamina_progress_bar.value > stamina_progress_bar.min_value):
		stamina_progress_bar.value -= 1  # Decrease stamina value.
	else:
		return false  # Return false if no stamina is left.
	
	return true  # Return true if stamina was successfully consumed.
	
	pass
	
# Resets the stamina progress bar to its maximum value.
func _reset_stamina_progress_bar() -> void:
	# @description: Resets the stamina progress bar to its maximum value.
	stamina_progress_bar.value = stamina_progress_bar.max_value  # Set value to max.
	
	pass
