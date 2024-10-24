extends Control

@export var chrono: Node

@onready var panel_container : PanelContainer = $PanelContainer
@onready var level_label: Label = $PanelContainer/VBoxContainer/LevelLabel
@onready var description_label : Label = $PanelContainer/DescriptionLabel
@onready var stamina_progress_bar : TextureProgressBar = $PanelContainer/StaminaProgressBar
@onready var collectible_popup_menu : PopupMenu = $PanelContainer/CollectiblePopupMenu


var action_popup_base_url : String = "https://entiendetumente.info/"
var url = ""


func _ready():
	SceneManager.scene_changed.connect(GameManager._on_scene_changed)
	
	pass
	
func _reset_gui() -> void:
	_show_gui(true)
	_on_show_description("", false)
	_on_show_collectible("", false)
	_on_set_chrono(true)
	_reset_stamina_progress_bar()
	
	pass
	
func _stop_gui() -> void:
	_show_gui(false)
	_on_show_description("", false)
	_on_show_collectible("", false)
	_on_set_chrono(false)
	_reset_stamina_progress_bar()
	
	pass
	
func _show_gui(state : bool) -> void:
	panel_container.visible = state
	
	pass

func _on_show_description(messg : String, state: bool) -> void:
	description_label.visible = state
	description_label.text = messg 
	
	pass
	
func _on_show_collectible(endpoint : String, state: bool) -> void:
	if(state): 
		collectible_popup_menu.show()
		url = action_popup_base_url + endpoint
	else: 
		collectible_popup_menu.hide()
	
	pass
	
func _on_set_chrono(state : bool) -> void:
	chrono.on_chrono = state
	chrono.reset_chrono()
	
	pass
	
func _consume_stamina_progress_bar() -> bool:
	if(stamina_progress_bar.value > stamina_progress_bar.min_value):
		stamina_progress_bar.value -= 1
	else:
		return false
	
	return true
	
	pass
	
func _reset_stamina_progress_bar() -> void:
	stamina_progress_bar.value = stamina_progress_bar.max_value
	
	pass

func _on_popup_menu_id_pressed(id):
	match(id):
		1: 
			OS.shell_open(url)
		2: 
			_on_show_collectible("", false)
		
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	pass 
