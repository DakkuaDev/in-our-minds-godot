# @description: Player movement and impulse handling script. Provides smooth movement with speed, velocity limits, and a time-slowing impulse effect with field of view (FOV) adjustment.
# @author: Daniel Guerra Gallardo. (@DakkuaDev)
# @date: 10/2024

extends RigidBody3D

# Exposed variables for configuration
@export var movement_speed : float = 385.0 # Speed of movement for central force application.
@export var max_velocity : float = 7.5 # Maximum linear velocity cap.
@export var impulse_force : float = 5.0 # Force applied during impulse.
@export var slowdown_factor: float = 0.2 # Time scale reduction factor during impulse.
@export var fov_change_amount : float = 15.0 # Amount by which FOV changes during impulse.

# Internal variables for FOV management
var original_fov : float # Stores the original FOV of the camera.
var impulse_fov : float # Adjusted FOV value for impulse effect.

# Node references
@onready var camera_3d : Camera3D = $"../CameraContainer/HRotation/VRotation/SpringArm3D/Camera3D" # Reference to the player's camera.
@onready var audioPlayer : AudioStreamPlayer3D = $"../AudioStreamPlayer3D" # Reference to 3D audio player.
@onready var original_time_scale : float = Engine.time_scale # Saves the original time scale of the engine.

# Initializes FOV values and sets initial states.
func _ready():
	original_fov = camera_3d.fov
	impulse_fov = original_fov - fov_change_amount
	pass 

# Physics processing to handle movement and impulse effects.
# @param delta: float - Time passed since the last frame.
func _physics_process(delta) -> void:
	# Clamp linear velocity to prevent exceeding max velocity.
	if linear_velocity.x > max_velocity:
		linear_velocity.x = max_velocity
	if linear_velocity.x < -max_velocity:
		linear_velocity.x = -max_velocity
	if linear_velocity.z > max_velocity:
		linear_velocity.z = max_velocity
	if linear_velocity.z < -max_velocity:
		linear_velocity.z = -max_velocity
	
	movement(delta) # Handles movement based on input.
	handle_impulse() # Manages impulse activation and effects.
	
	pass
	
# Processes player movement based on input directions relative to the camera.
# @param delta: float - Time passed since the last frame.
func movement(delta) -> void:
	var f_input = Input.get_action_raw_strength("backward") - Input.get_action_raw_strength("forward")
	var h_input = Input.get_action_raw_strength("right") - Input.get_action_raw_strength("left")
	
	var camera_transform = camera_3d.get_camera_transform()
	
	# Determine direction relative to the camera's orientation.
	var relative_camera_direction_z = camera_transform.basis.z.normalized()
	var relative_camera_direction_x = camera_transform.basis.x.normalized()
	
	# Apply force based on directional input.
	var direction_f = f_input * relative_camera_direction_z
	var direction_h = h_input * relative_camera_direction_x
	
	apply_central_force(direction_f * movement_speed * delta)
	apply_central_force(direction_h * movement_speed * delta)
	pass
	
# Internal variable for impulse state
var is_holding_impulse = false # Tracks if the impulse is currently being held.

# Handles impulse activation, including time scaling and audio feedback.
func handle_impulse() -> void:
	if Input.is_action_just_pressed("impulse"):
		# Attempt to consume stamina for impulse; if successful, activate impulse effects.
		if(Gui._consume_stamina_progress_bar()):
			Engine.time_scale = slowdown_factor # Slow down time for dramatic effect.
			
			audioPlayer.pitch_scale = 0.5 # Lower pitch to match slowed time.
			audioPlayer.play() # Play audio effect.
			
			is_holding_impulse = true
	
	# Ends impulse effects and applies final impulse force.
	if Input.is_action_just_released("impulse"):
		if(is_holding_impulse):
			Engine.time_scale = original_time_scale # Restore normal time scale.
			
			var camera_transform = camera_3d.get_camera_transform()
			var forward_direction = -camera_transform.basis.z.normalized() # Determines impulse direction.
			
			is_holding_impulse = false
		
			apply_impulse(forward_direction * impulse_force) # Apply forward force impulse.

			var rng = RandomNumberGenerator.new() # Generates a random pitch for audio variation.
			
			audioPlayer.pitch_scale = rng.randf_range(1, 2.5)
			audioPlayer.play() # Play audio with varied pitch.
		else:
			# The user cannot perform the impulse action.
			pass
		
	pass
