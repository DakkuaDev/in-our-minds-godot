# @description: Camera control script that smoothly follows a "Marble" object and allows horizontal and vertical rotations based on mouse input. Configurable for sensitivity, acceleration, and camera limits.
# @author: Daniel Guerra Gallardo. (@DakkuaDev)
# @date: 10/2024

extends Node3D

# Exposed variables for configuration
@export_category("Configurables")
@export var cam_v_max : float = 110.0 # Maximum vertical angle limit for camera rotation.
@export var cam_v_min : float = -75.0 # Minimum vertical angle limit for camera rotation.
@export var h_sensitivity : float = 0.1 # Horizontal sensitivity for mouse movement.
@export var v_sensitivity : float = 0.1 # Vertical sensitivity for mouse movement.
@export var h_acceleration : float = 15.0 # Acceleration for horizontal rotation smoothing.
@export var v_acceleration : float = 15.0 # Acceleration for vertical rotation smoothing.
@export var smooth_camera_tolerance : float = .3 # Tolerance for smooth camera position following.

# Node references
@onready var marble = $"../Marble" # Reference to the target "Marble" object.
@onready var h_rotation: Node3D = $HRotation # Node for handling horizontal rotation.
@onready var v_rotation: Node3D = $HRotation/VRotation # Node for handling vertical rotation.

# Internal variables
var camrot_h : float = 0.0 # Stores horizontal camera rotation.
var camrot_v : float = 0.0 # Stores vertical camera rotation.

# Updates camera position and rotation every physics frame.
# @param delta: float - Time passed since the last frame.
func _physics_process(delta):
	# Smoothly follows the Marble's position with a tolerance factor.
	global_position = lerp(global_position, marble.get_node("MeshInstance3D").global_position, smooth_camera_tolerance)
	
	# Clamps the vertical rotation within min and max limits.
	camrot_v = clamp(camrot_v, cam_v_min, cam_v_max)
	
	# Smoothly interpolates horizontal and vertical rotations based on acceleration factors.
	h_rotation.rotation_degrees.y = lerp(h_rotation.rotation_degrees.y, camrot_h, delta * h_acceleration)
	v_rotation.rotation_degrees.x = lerp(v_rotation.rotation_degrees.x, camrot_v, delta * v_acceleration)
	rotation_degrees.z = 0 # Resets roll rotation to zero to avoid tilt.

# Handles mouse input for rotating the camera.
# @param event: InputEvent - The input event, specifically for mouse motion.
func _input(event):
	if event is InputEventMouseMotion:
		# Adjusts the horizontal and vertical rotation based on mouse movement and sensitivity.
		camrot_h += -event.relative.x * h_sensitivity
		camrot_v += -event.relative.y * v_sensitivity

