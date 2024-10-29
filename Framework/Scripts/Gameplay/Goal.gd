# @description: Handles scene transition when the player interacts with a specific 3D area. Configurable options allow for smooth, patterned fades and various effects during transitions, including an optional chapter menu display.
# @author: Daniel Guerra Gallardo. (@DakkuaDev)
# @date: 10/2024

extends Node3D

# Exposed variables
@export var scene: String # The target scene to load when the area is triggered.
@export var next_scene_is_chapter_menu : bool = false # If true, the next scene is the chapter menu.
@export var fade_out_speed: float = 1.0 # Speed of the fade-out transition.
@export var fade_in_speed: float = 1.0 # Speed of the fade-in transition.
@export var fade_out_pattern: String = "fade" # Pattern type for fade-out effect.
@export var fade_in_pattern: String = "fade" # Pattern type for fade-in effect.
@export var fade_out_smoothness: float = 0.1 # Smoothness of fade-out, range from 0 (sharp) to 1 (smooth).
@export var fade_in_smoothness: float = 0.1 # Smoothness of fade-in, range from 0 to 1.
@export var fade_out_inverted: bool = false # If true, inverts the fade-out effect.
@export var fade_in_inverted: bool = false # If true, inverts the fade-in effect.
@export var color: Color = Color(0, 0, 0) # Background color used during transition.
@export var timeout: float = 0.0 # Delay duration before triggering transition.
@export var clickable: bool = false # Determines if the area is clickable.
@export var add_to_back: bool = true # If true, scene is added to the back of the stack.

# Node references
@onready var audio_stream_player_3d : AudioStreamPlayer3D = $AudioStreamPlayer3D # Audio player for sounds during area interaction.

# Transition options
@onready var fade_out_options = SceneManager.create_options(fade_out_speed, fade_out_pattern, fade_out_smoothness, fade_out_inverted) # Fade-out settings.
@onready var fade_in_options = SceneManager.create_options(fade_in_speed, fade_in_pattern, fade_in_smoothness, fade_in_inverted) # Fade-in settings.
@onready var general_options = SceneManager.create_general_options(color, timeout, clickable, add_to_back) # General transition settings.

# Called when the node is ready.
func _ready() -> void:
	# Initializes the first scene with fade-in and color options.
	var fade_in_first_scene_options = SceneManager.create_options(1, "fade")
	var first_scene_general_options = SceneManager.create_general_options(Color(0, 0, 0), 1, false)
	SceneManager.show_first_scene(fade_in_first_scene_options, first_scene_general_options)
	
	# Validates scene and pattern options to ensure they are recognized by the SceneManager.
	SceneManager.validate_scene(scene) # Code breaks if scene is unrecognized.
	SceneManager.validate_pattern(fade_out_pattern) # Code breaks if pattern is unrecognized.
	SceneManager.validate_pattern(fade_in_pattern)

# Triggered when a physics body enters the area.
# @param body: RigidBody3D - The physics body entering the area, checked for player group membership.
func _on_area_3d_body_entered(body) -> void:
	if body.is_in_group("Player"):
		# Plays audio and triggers the transition to the next level when the player enters.
		audio_stream_player_3d.play()
		_go_next_level()

# Manages the transition to the next level or chapter menu.
func _go_next_level() -> void:
	if next_scene_is_chapter_menu:
		# If set, shows the chapter menu instead of changing to a new scene.
		GameManager._on_show_chapter_menu()
	else:
		if scene == "":
			# If no scene is specified, resets the game.
			GameManager._reset_game()
		else:
			# Changes to the specified scene with configured fade and general options.
			SceneManager.change_scene(scene, fade_out_options, fade_in_options, general_options)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Captures mouse for new scene.

