extends CharacterBody3D


const SPEED = 0.5
const FLY_VELOCITY = 0.5

const ROTATION_MAX_DEGREE = 50

var GRAVITY_MULTIPLIER_WHEN_FLYING = 0.2
var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity") *  GRAVITY_MULTIPLIER_WHEN_FLYING

@onready var twist_pivot = $TwistPivot
@onready var pitch_pivot = $TwistPivot/PitchPivot
@onready var camera = $TwistPivot/PitchPivot/Camera3D
var ROTATION_SPEED = 90.0  # degrees per second

func rotate_camera(delta: float):
	var yaw = 0.0
	var pitch = 0.0

	if Input.is_action_pressed("rotate_left"):
		yaw += ROTATION_SPEED * delta
	if Input.is_action_pressed("rotate_right"):
		yaw -= ROTATION_SPEED * delta
	if Input.is_action_pressed("rotate_up"):
		pitch += ROTATION_SPEED * delta
	if Input.is_action_pressed("rotate_down"):
		pitch -= ROTATION_SPEED * delta
	#print(yaw)
	# Rotate this node (TwistPivot) around Y
	twist_pivot.rotate_y(deg_to_rad(yaw))

	# Rotate PitchPivot around X, with clamping
	var current_pitch = pitch_pivot.rotation.x
	current_pitch = current_pitch + deg_to_rad(pitch)
	var min_pitch = deg_to_rad(-(ROTATION_MAX_DEGREE))
	var max_pitch = deg_to_rad(ROTATION_MAX_DEGREE)
	current_pitch = clamp(current_pitch, min_pitch, max_pitch)
	pitch_pivot.rotation.x = current_pitch

func _physics_process(delta: float) -> void:
	rotate_camera(delta)	
	
	var forward = camera.global_transform.basis.z
	var right = camera.global_transform.basis.x
	
	
	var input_direction := Vector3.ZERO
	input_direction.z = Input.get_axis("move_forward","move_back")
	
	if Input.is_action_pressed("fly"):
		input_direction.x = Input.get_axis("move_left","move_right")
		velocity.y = FLY_VELOCITY
	else:
		velocity.y -= GRAVITY * delta
	
	var direction = (right * input_direction.x + forward * input_direction.z).normalized()
	
	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		velocity.y -= GRAVITY * delta
	else:
		velocity.x = lerp(velocity.x, 0.0, SPEED * delta)
		velocity.z = lerp(velocity.z, 0.0, SPEED * delta)

	move_and_slide()
