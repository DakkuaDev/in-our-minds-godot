# @description: Description-trigger script for a 3D area that displays text and plays audio when a player enters. Hides the description after the player exits the area and a timer elapses. Useful for interactive points of interest in the 3D environment.
# @author: Daniel Guerra Gallardo. (@DakkuaDev)
# @date: 10/2024

extends Node3D

# Exposed variables
@export var description : String = "" # Text description shown in the GUI when the player enters the area.

# Node references
@onready var audio_stream_player_3d : AudioStreamPlayer3D = $AudioStreamPlayer3D # Audio player that plays sound when player enters the area.
@onready var timer : Timer = $Timer # Timer used to delay hiding the description after the player exits the area.

# Triggered when a physics body enters the area.
# @param body: RigidBody3D - The physics body entering the area, checked for player group membership.
func _on_area_3d_body_entered(body : RigidBody3D) -> void:
	if body.is_in_group("Player"):
		# Plays audio and displays description text in the GUI when player enters.
		audio_stream_player_3d.play()
		Gui._on_show_description(description, true)

# Triggered when a physics body exits the area.
# @param body: RigidBody3D - The physics body exiting the area, checked for player group membership.
func _on_area_3d_body_exited(body : RigidBody3D) -> void:
	if body.is_in_group("Player"):
		# Starts timer to delay hiding the description after exit.
		timer.start()

# Triggered when the timer completes, hides the description in the GUI.
func _on_timer_timeout() -> void:
	Gui._on_show_description("", false) # Clears and hides the description in the GUI.
	timer.stop() # Stops the timer to reset it.

