extends CharacterBody3D


const SPEED = 5.0

var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")
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
	print(yaw)
	# Rotate this node (TwistPivot) around Y
	twist_pivot.rotate_y(deg_to_rad(yaw))

	# Rotate PitchPivot around X, with clamping
	var current_pitch = pitch_pivot.rotation.x
	current_pitch = current_pitch + deg_to_rad(pitch)
	pitch_pivot.rotation.x = current_pitch

func _physics_process(delta: float) -> void:
	rotate_camera(delta)	
	
	var forward = camera.global_transform.basis.z
	var right = camera.global_transform.basis.x
	
	
	var input_direction := Vector3.ZERO
	input_direction.x = Input.get_axis("move_left","move_right")
	input_direction.z = Input.get_axis("move_forward","move_back")
	
	var direction = (right * input_direction.x + forward * input_direction.z).normalized()
	
	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		velocity.y -= GRAVITY * delta
	else:
		velocity = velocity.move_toward(Vector3.ZERO, SPEED)

	move_and_slide()
