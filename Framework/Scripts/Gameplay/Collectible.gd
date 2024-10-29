extends Node3D

@onready var audio_stream_player_3d : AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var action_popup_menu : PopupMenu = $PanelContainer/CollectiblePanel/ActionPopupMenu

@export var endpoint : String = ""

func _on_area_3d_body_entered(body : RigidBody3D) -> void:
	if body.is_in_group("Player"):
		audio_stream_player_3d.play()
		
		Gui._on_show_collectible(endpoint, true)
		
		queue_free()
				
	pass
