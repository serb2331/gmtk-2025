extends CharacterBody3D

# i guess use m/s for speed and such(?)

const SPEED = 25
const FLY_VELOCITY = 0.2

const ROTATION_MAX_DEGREE = 50

const GRAVITY_MULTIPLIER_WHEN_FLYING = 0.02
var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity") *  GRAVITY_MULTIPLIER_WHEN_FLYING

@onready var TwistPivot : Node3D = $TwistPivot
@onready var PitchPivot : Node3D = $TwistPivot/PitchPivot
@onready var Camera := $TwistPivot/PitchPivot/Camera3D
@onready var Model : Node3D = $Fly
@onready var FlyAnimation : AnimationPlayer = $Fly/AnimationPlayer
const ROTATION_SPEED = 90.0  # degrees per second
const MIN_PITCH = deg_to_rad(-(ROTATION_MAX_DEGREE))
const MAX_PITCH = deg_to_rad(ROTATION_MAX_DEGREE)
const DECELERATION = 5
const CAMERA_SENSITIVITY = 0.01

# func rotate_camera(delta: float):
# 	var _yaw = 0.0
# 	var _pitch = 0.0

# 	if Input.is_action_pressed("rotate_left"):
# 		_yaw += ROTATION_SPEED * delta
# 	if Input.is_action_pressed("rotate_right"):
# 		_yaw -= ROTATION_SPEED * delta
# 	if Input.is_action_pressed("rotate_up"):
# 		_pitch += ROTATION_SPEED * delta
# 	if Input.is_action_pressed("rotate_down"):
# 		_pitch -= ROTATION_SPEED * delta
# 	# Rotate this node (TwistPivot) around Y
# 	TwistPivot.rotate_y(deg_to_rad(_yaw))

# 	# Rotate PitchPivot around X, with clamping
# 	var current_pitch = PitchPivot.rotation.x
# 	current_pitch = current_pitch + deg_to_rad(_pitch)
# 	current_pitch = clamp(current_pitch, MIN_PITCH, MAX_PITCH)
# 	PitchPivot.rotation.x = current_pitch\

var _target_camera_yaw := deg_to_rad(180)
var _target_camera_pitch := deg_to_rad(-45)

func _rotateCamera() -> void:
	TwistPivot.rotation.y = lerp_angle(TwistPivot.rotation.y, _target_camera_yaw, 0.1);
	PitchPivot.rotation.x = lerp_angle(PitchPivot.rotation.x, _target_camera_pitch, 0.1);
	
func _rotateModel() -> void:
	Model.rotation.x = -PitchPivot.rotation.x;
	Model.rotation.y = TwistPivot.rotation.y - PI;

#############

func _ready() -> void:
	print("FlyAnimation: ", FlyAnimation)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	_rotateCamera()
	_rotateModel()
	
	var _forward = Camera.global_transform.basis.z
	var _right = Camera.global_transform.basis.x
	
	
	var _input_direction := Vector3.ZERO
	_input_direction.z = Input.get_axis("move_forward","move_back")
	if velocity.y != 0:
		_input_direction.x = Input.get_axis("move_left","move_right")

	if Input.is_action_pressed("fly"):
		velocity.y = FLY_VELOCITY
	else:
		velocity.y -= GRAVITY * delta
	
	

	var _direction = (_right * _input_direction.x + _forward * _input_direction.z).normalized()
	
	if _direction != Vector3.ZERO:
		velocity.x = _direction.x * SPEED * delta
		velocity.z = _direction.z * SPEED * delta
		velocity.y -= GRAVITY * delta
	else:
		if is_on_floor():
			velocity.x = 0.0
			velocity.z = 0.0
		else:
			velocity.x = lerp(velocity.x, 0.0, DECELERATION * delta)
			velocity.z = lerp(velocity.z, 0.0, DECELERATION * delta)

	move_and_slide()

	var desired_animation := ""

	if velocity.y != 0:
		desired_animation = "fly"
	elif is_on_floor():
		var is_moving = abs(velocity.x) > 0.1 or abs(velocity.z) > 0.1
		if is_moving:
			desired_animation = "walk"
		else:
			desired_animation = "idle"
	else:
		desired_animation = "idle" 

	if FlyAnimation.current_animation != desired_animation:
		FlyAnimation.play(desired_animation)

func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion):
		# print(event.screen_relative)

		# rotate camera
		var _yaw := 0.0
		var _pitch := 0.0

		_yaw = -event.screen_relative.x * CAMERA_SENSITIVITY
		_pitch = -event.screen_relative.y * CAMERA_SENSITIVITY

		print(_yaw, " ---- ", _pitch);

		# TwistPivot.rotate_y(_yaw);
		# PitchPivot.rotate_x(_pitch);

		_target_camera_yaw += _yaw;
		_target_camera_pitch += _pitch;
