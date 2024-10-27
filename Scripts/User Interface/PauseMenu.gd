extends Control

@onready var options_menu = $Panel/OptionsMenu


func _ready():
	visible = false
	
func _process(delta):
		
	if Input.is_action_just_pressed("exit"):
		options_menu.visible = false
		
	pass
	
func _reset() -> void:
	visible = false
	
	GameManager._freeze_game(false)
	
	pass

func _on_btn_continue_button_down() -> void:
	_reset()

	pass

func _on_btn_main_menu_button_down() -> void:
	_reset()
	
	GameManager._reset_game()
	
	pass


func _on_btn_options_button_down():
	options_menu.visible = true
	
	pass 
