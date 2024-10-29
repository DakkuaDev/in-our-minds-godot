extends Node3D

@export var scene: String
@export var next_scene_is_chapter_menu : bool = false
@export var fade_out_speed: float = 1.0
@export var fade_in_speed: float = 1.0
@export var fade_out_pattern: String = "fade"
@export var fade_in_pattern: String = "fade"
@export var fade_out_smoothness = 0.1 # (float, 0, 1)
@export var fade_in_smoothness = 0.1 # (float, 0, 1)
@export var fade_out_inverted: bool = false
@export var fade_in_inverted: bool = false
@export var color: Color = Color(0, 0, 0)
@export var timeout: float = 0.0
@export var clickable: bool = false
@export var add_to_back: bool = true

@onready var audio_stream_player_3d : AudioStreamPlayer3D = $AudioStreamPlayer3D

@onready var fade_out_options = SceneManager.create_options(fade_out_speed, fade_out_pattern, fade_out_smoothness, fade_out_inverted)
@onready var fade_in_options = SceneManager.create_options(fade_in_speed, fade_in_pattern, fade_in_smoothness, fade_in_inverted)
@onready var general_options = SceneManager.create_general_options(color, timeout, clickable, add_to_back)

func _ready() -> void:
	var fade_in_first_scene_options = SceneManager.create_options(1, "fade")
	var first_scene_general_options = SceneManager.create_general_options(Color(0, 0, 0), 1, false)
	SceneManager.show_first_scene(fade_in_first_scene_options, first_scene_general_options)
 # code breaks if scene is not recognizable
	SceneManager.validate_scene(scene)
 # code breaks if pattern is not recognizable
	SceneManager.validate_pattern(fade_out_pattern)
	SceneManager.validate_pattern(fade_in_pattern)
	
	pass
	
func _on_area_3d_body_entered(body) -> void:
	if body.is_in_group("Player"):
		audio_stream_player_3d.play()
		_go_next_level()
			
	pass
	
func _go_next_level() -> void:
	if(next_scene_is_chapter_menu): 
			GameManager._on_show_chapter_menu()  # next scene is shows chapter menu
			pass
	else:	
		if(scene == ""): # if there is not scene set, reset the game 
			GameManager._reset_game()
		else: 
			SceneManager.change_scene(scene, fade_out_options, fade_in_options, general_options)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
	pass
