extends RigidBody3D

#var LineDrawer = preload("res://Scripts/DrawLine3D.gd").new()

@export var movement_speed : float = 385.0
@export var max_speed : float = 7.5

@export var jump_force : float = 25.0
@export var gravity : float = -9.81

var vertical_velocity : float = 0.0
@export var ray_cast_3d_yOffset : float = 2;

@onready var camera_3d : Camera3D = $"../Camera3D"
@onready var ray_cast_3d = $"RayCast3D"


func _ready() -> void:
	#add_child(LineDrawer)
	pass

func _physics_process(delta: float) -> void:
	movement(delta)
	jump(delta)
	
# Player physical movement
# params: delta: float - time between frames
func movement(delta : float) -> void:
	
	# Get the input from the player
	var f_input: float = Input.get_action_strength("backward") - Input.get_action_strength("forward")
	var h_input: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	# Get the camera transform
	var camera_transform = camera_3d.get_camera_transform()
	
	# Get the camera direction
	var relative_camera_direction_x = camera_transform.basis.x.normalized()
	var relative_camera_direction_z = camera_transform.basis.z.normalized()
	
	# Calculate the direction of the movement
	var direction_f = f_input * relative_camera_direction_z
	var direction_h = h_input * relative_camera_direction_x
	
	# Apply the force to the player
	apply_central_force(direction_f * movement_speed * delta)
	apply_central_force(direction_h * movement_speed * delta)

# Player jump
# params: delta: float - time between frames
func jump(delta : float) -> void:
	
	# Move manually raycast position
	ray_cast_3d.position = Vector3(
		position.x, 
		position.y + ray_cast_3d_yOffset, 
		position.z)

	# Apply gravity
	vertical_velocity += gravity * delta

	# Check if the player has pressed the jump button
	if Input.is_action_just_pressed("jump"):
		vertical_velocity = jump_force
				
	vertical_velocity += gravity * delta

	# Apply the vertical velocity to the player
	if(is_on_ground()):
		apply_central_force(Vector3(0, vertical_velocity, 0))	
	

# Check if player is on ground 
func is_on_ground() -> bool:
	
	# Draw raycast line (debug)
	#LineDrawer.DrawLine(
		#ray_cast_3d.position, 
		#ray_cast_3d.position + ray_cast_3d.target_position, 
		#Color.RED
		#)
	
	# Check raycast
	if(ray_cast_3d.is_colliding()):
		return true
	else:
		return false

