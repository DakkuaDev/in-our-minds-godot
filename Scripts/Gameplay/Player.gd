extends RigidBody3D

@export var movement_speed : float = 385.0
@export var max_velocity : float = 7.5
@export var impulse_force : float = 5.0
@export var slowdown_factor: float = 0.2
@export var fov_change_amount : float = 15.0 

var original_fov : float
var impulse_fov : float

@onready var camera_3d : Camera3D = $"../CameraContainer/HRotation/VRotation/SpringArm3D/Camera3D"
@onready var audioPlayer : AudioStreamPlayer3D = $"../AudioStreamPlayer3D"
@onready var original_time_scale : float = Engine.time_scale

func _ready():
	original_fov = camera_3d.fov
	impulse_fov = original_fov - fov_change_amount

	pass 

func _physics_process(delta) -> void:
	if linear_velocity.x > max_velocity:
		linear_velocity.x = max_velocity
	if linear_velocity.x < -max_velocity:
		linear_velocity.x = -max_velocity
	if linear_velocity.z > max_velocity:
		linear_velocity.z = max_velocity
	if linear_velocity.z < -max_velocity:
		linear_velocity.z = -max_velocity
	
	movement(delta)
	handle_impulse()
	
	pass
	
func movement(delta) -> void:
	var f_input = Input.get_action_raw_strength("backward") - Input.get_action_raw_strength("forward")
	var h_input = Input.get_action_raw_strength("right") - Input.get_action_raw_strength("left")
	
	var camera_tranform = camera_3d.get_camera_transform()
	
	var relative_camera_direction_z = camera_tranform.basis.z.normalized()
	var relative_camera_direction_x = camera_tranform.basis.x.normalized()
	
	var direction_f = f_input * relative_camera_direction_z
	var direction_h = h_input * relative_camera_direction_x
	
	apply_central_force(direction_f * movement_speed * delta)
	apply_central_force(direction_h * movement_speed * delta)
	pass
	
var is_holding_impulse = false

func handle_impulse() -> void:
	if Input.is_action_just_pressed("impulse"):
		if(Gui._consume_stamina_progress_bar()):
			Engine.time_scale = slowdown_factor
			
			audioPlayer.pitch_scale = 0.5
			audioPlayer.play()
			
			is_holding_impulse = true
	
	if Input.is_action_just_released("impulse"):
		if(is_holding_impulse):
			Engine.time_scale = original_time_scale
			
			var camera_transform = camera_3d.get_camera_transform()
			var forward_direction = -camera_transform.basis.z.normalized()  
			
			is_holding_impulse = false
		
			apply_impulse(forward_direction * impulse_force)

			var rng = RandomNumberGenerator.new()
			
			audioPlayer.pitch_scale = rng.randf_range(1,2.5)
			audioPlayer.play()
		else:
			#the user cannot impulse
			pass
		
	pass
