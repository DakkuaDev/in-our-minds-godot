extends Control

@export var scene: String
@export var first_scene: bool = false
@export var timer_time: float = 2.5
@export var music_to_play : String = ""

@onready var btn_start : Button = $Panel/VBoxContainer/BtnStart
@onready var timer : Timer = $Timer

@onready var lbl_title : Label = $Panel/VBoxContainer/LblTitle

func _ready():
	AudioManager.play_music(music_to_play, true, true, true, 2.0)
	
	timer.start(timer_time)
	btn_start.visible = false
	
	pass

func _on_btn_start_button_down() -> void:
	GameManager._start_game(scene)
	
	pass

func _on_btn_exit_button_down():
	GameManager._reset_game()
	pass 
	
func _on_timer_timeout() -> void:
	timer.stop()
	btn_start.visible = true
	
	pass


