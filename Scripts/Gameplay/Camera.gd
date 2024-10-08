extends Node3D

@export_category("Configurables")

@export var cam_v_max : float = 110.0
@export var cam_v_min : float = -75.0
@export var h_sensitivity : float = 0.1
@export var v_sensitivity : float = 0.1
@export var h_acceleration : float = 15.0
@export var v_acceleration : float = 15.0
@export var smooth_camera_tolerance : float = .3

@onready var marble = $"../Marble"
@onready var h_rotation: Node3D = $HRotation
@onready var v_rotation: Node3D = $HRotation/VRotation

var camrot_h : float = 0.0
var camrot_v : float = 0.0
	
func _physics_process(delta):
	global_position = lerp(global_position, marble.get_node("MeshInstance3D").global_position,smooth_camera_tolerance)
	
	camrot_v = clamp(camrot_v, cam_v_min, cam_v_max)
	
	h_rotation.rotation_degrees.y = lerp(h_rotation.rotation_degrees.y, camrot_h, delta * h_acceleration)
	v_rotation.rotation_degrees.x = lerp(v_rotation.rotation_degrees.x, camrot_v, delta * v_acceleration)
	rotation_degrees.z = 0
	
	pass
	
func _input(event):
	if event is InputEventMouseMotion:
		camrot_h += -event.relative.x * h_sensitivity
		camrot_v += -event.relative.y * v_sensitivity
		
	pass

