# @description: 3D Collectible Item script, handling player interaction, audio playback, and GUI updates when the player collects an item in the 3D world. Automatically frees the collectible after collection.
# @author: Daniel Guerra Gallardo. (@DakkuaDev)
# @date: 10/2024

extends Node3D

# Exposed variables
@export var endpoint : String = "" # Identifier or name associated with the collectible, sent to GUI upon collection.

# Node references
@onready var audio_stream_player_3d : AudioStreamPlayer3D = $AudioStreamPlayer3D # 3D audio player for collectible sound.
@onready var action_popup_menu : PopupMenu = $PanelContainer/CollectiblePanel/ActionPopupMenu # Popup menu for collectible actions, displayed in the GUI.

# Triggered when a physics body enters the collectible's area.
# @param body: RigidBody3D - The physics body that entered the area, checked for player group membership.
func _on_area_3d_body_entered(body : RigidBody3D) -> void:
	# Plays sound and shows collectible information in the GUI if player collects item.
	if body.is_in_group("Player"):
		audio_stream_player_3d.play()
		
		# Updates GUI to display collectible details based on the endpoint identifier.
		Gui._on_show_collectible(endpoint, true)
		
		# Frees the collectible from the scene after interaction.
		queue_free()

