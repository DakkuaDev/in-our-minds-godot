# @description: Game Manager script to handle game states, scenes, GUI updates, and input events such as pausing and exiting the game.
# @author: Daniel Guerra Gallardo. (@DakkuaDev)
# @date: 10/2024

extends Node 

# Exposed variables
@onready var current_level_name: String = "" # Name of the current level displayed in the GUI.

# Internal variables
var current_chapter_index: int = -1 # Index of the current chapter or level.
enum GUI_STATE {ENABLE, DISABLE} # GUI visibility state.
enum GUI_MODE  {CONTINUE, RESET, STOP} # GUI behavior modes.
var is_on_game: bool = false # True if the game is currently active.
var full_screen_mode: bool = false # Whether the game is in fullscreen mode.

# Initializes game settings and resets the game to start conditions.
func _ready():
	TranslationServer.set_locale("en") # Sets default language to English.
	_reset_game()

func _process(delta):
	# Checks for input to handle pausing and reloading the game scene.
	if is_on_game:
		if Input.is_action_just_pressed("exit"):
			# Freezes game and shows pause menu on "exit" action.
			_freeze_game(true)
			PauseMenu.visible = true
			
		if Input.is_action_just_pressed("reload"):
			# Reloads current scene on "reload" action.
			_reload_scene()

# Shows the chapter menu and disables gameplay inputs.
func _on_show_chapter_menu() -> void:
	SceneManager._change_scene("ChapterMenu" + str(current_chapter_index), true)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_on_chapter_changed()
	is_on_game = false

# Updates the chapter index and GUI state after changing chapters.
func _on_chapter_changed() -> void:
	current_chapter_index += 1
	_update_gui(GUI_STATE.DISABLE, GUI_MODE.STOP)

# Starts the specified game scene.
# @param scene: String - The name of the scene to load.
func _start_game(scene : String) -> void:	
	SceneManager._change_scene(scene, true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_on_scene_changed()
	is_on_game = true

# Returns the scene name based on the current index.
# @param current_index: int - The index of the current scene.
# @return String - The localized name of the level.
func _update_scene_name(current_index : int) -> String:
	match current_index:
		0: return tr("LEVEL_1_NAME")
		1: return tr("LEVEL_2_NAME")
		2: return tr("LEVEL_3_NAME")
		3: return tr("LEVEL_4_NAME")
		4: return tr("LEVEL_5_NAME")
	return "null"

# Updates the current scene and GUI state after changing scenes.
func _on_scene_changed() -> void:
	SceneManager._current_scene_number += 1
	_update_gui(GUI_STATE.ENABLE, GUI_MODE.RESET)

# Reloads the current scene and resets GUI state.
func _reload_scene() -> void:
	SceneManager._change_scene("reload", true)
	_update_gui(GUI_STATE.ENABLE, GUI_MODE.RESET)

# Resets the game to its starting state, returning to the main menu.
func _reset_game() -> void:
	current_level_name = ""
	current_chapter_index = 0
	SceneManager._current_scene_number = -1
	SceneManager._change_scene("MainMenu", true)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_update_gui(GUI_STATE.DISABLE, GUI_MODE.STOP)
	is_on_game = false

# Exits the game by switching to the exit scene.
func _exit_game() -> void:
	SceneManager._change_scene("exit", true)

# Updates GUI elements based on the state and mode specified.
# @param state: int - The GUI state (ENABLE or DISABLE).
# @param mode: int - The GUI mode (CONTINUE, RESET, or STOP).
func _update_gui(state : int, mode : int) -> void:
	current_level_name = _update_scene_name(SceneManager._current_scene_number)
	Gui.level_label.text = current_level_name
	
	match state:
		GUI_STATE.ENABLE:
			Gui._show_gui(true)
		GUI_STATE.DISABLE:
			Gui._show_gui(false)
			
	match mode:
		GUI_MODE.CONTINUE:
			pass
		GUI_MODE.RESET:
			Gui._reset_gui()
		GUI_MODE.STOP:
			Gui._stop_gui()

# Freezes or unfreezes the game and sets mouse visibility.
# @param state: bool - True to freeze the game, false to unfreeze.
func _freeze_game(state : bool) -> void:
	get_tree().paused = state
	if state:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
