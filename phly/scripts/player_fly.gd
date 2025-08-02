extends CharacterBody3D

# i guess use m/s for speed and such(?)

const SPEED = 25
const FLY_VELOCITY = 0.2

const ROTATION_MAX_DEGREE = 50	

const GRAVITY_MULTIPLIER_WHEN_FLYING = 0.02
const ACCELERATION = 8
const MAX_SPEED = 1
var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var TwistPivot : Node3D = $TwistPivot
@onready var PitchPivot : Node3D = $TwistPivot/PitchPivot
@onready var Camera := $TwistPivot/PitchPivot/Camera3D
@onready var Model : Node3D = $Fly
@onready var animation_tree: AnimationTree = $Fly/AnimationTree
const ROTATION_SPEED = 90.0  
@onready var FlyAnimation : AnimationPlayer = $Fly/AnimationPlayer
@onready var FlyingSound : AudioStreamPlayer = $FlyingSound
@onready var WalkingSound : AudioStreamPlayer = $WalkingSound
const MIN_PITCH = deg_to_rad(-(ROTATION_MAX_DEGREE))
const MAX_PITCH = deg_to_rad(ROTATION_MAX_DEGREE)
const CAMERA_SENSITIVITY = 0.01
const YAW_THRESHOLD = deg_to_rad(0.5)

var _target_camera_yaw := deg_to_rad(180)
var _target_camera_pitch := deg_to_rad(-45)
var _last_camera_yaw := 0.0

func _rotateCamera() -> void:
	TwistPivot.rotation.y = lerp_angle(TwistPivot.rotation.y, _target_camera_yaw, 0.1);
	PitchPivot.rotation.x = lerp_angle(PitchPivot.rotation.x, _target_camera_pitch, 0.1);
	
func _rotateModel() -> void:
	Model.rotation.x = -PitchPivot.rotation.x;
	Model.rotation.y = TwistPivot.rotation.y - PI;

func _handleMovement(delta) -> void:

	var _is_moving := false;
	var _move_direction := Vector3.ZERO;	

	# Move forward (W) — horizontal plane only
	if Input.is_action_pressed("move_forward"):
		_move_direction -= Camera.global_transform.basis.z
		_is_moving = true;

	if Input.is_action_pressed("move_back"):
		_move_direction += Camera.global_transform.basis.z
		_is_moving = true;

	if Input.is_action_pressed("fly"):
		_move_direction += Camera.global_transform.basis.y
		_is_moving = true;

	###############

	velocity = lerp(velocity, Vector3.ZERO, 0.1);

	if (_is_moving):
		velocity += _move_direction * ACCELERATION * delta;
	else:
		if (!is_on_floor()):
			velocity += Vector3.DOWN * GRAVITY * delta;

	print(velocity.length())

	velocity.limit_length(MAX_SPEED);

	move_and_slide()

func _decideAndApplyAnimation() -> void:
	var yaw_diff = _target_camera_yaw - _last_camera_yaw
	_last_camera_yaw = _target_camera_yaw

	var desired_animation := "born"
	
	if velocity.y != 0:
		desired_animation = "fly"
	elif is_on_floor():
		var is_moving = abs(velocity.x) > 0.1 or abs(velocity.z) > 0.1
		if is_moving:
			desired_animation = "walk"
		else:
			if yaw_diff > YAW_THRESHOLD:
				desired_animation = "walk_left"
			elif yaw_diff < -YAW_THRESHOLD:
				desired_animation = "walk_right"
			else:
				desired_animation = "born"
	else:
		desired_animation = "born"

	if Input.is_action_pressed("eat") and GameState.inside_food:
		desired_animation = "eat"
	if GameState.is_respawning:
		desired_animation = "born"
	if GameState.is_dying:
		desired_animation = "die"	
	var playback = animation_tree.get("parameters/playback")
	if playback.get_current_node() != desired_animation:
		playback.travel(desired_animation)

#############

func _ready() -> void:
	GameState.player = self
	_last_camera_yaw = _target_camera_yaw
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	# print("CAMERA - ", Camera.global_transform.basis.y);
	# print("PITCH PIVOT - ", PitchPivot.global_transform.basis.y);
	if !GameState.is_respawning && !GameState.is_dying:
		_rotateCamera()
		_rotateModel()
		if is_on_floor():
			_target_camera_pitch = deg_to_rad(-15)

		_handleMovement(delta);
		_decideAndApplyAnimation();	if GameState.inside_food:
			if Input.is_action_pressed("eat"):
				_on_eat_pressed(delta)
		if Input.is_action_just_pressed("respawn"):
			GameState.set_respawn(global_transform.origin)
		if velocity.y != 0:
			if not FlyingSound.playing:
				FlyingSound.play()
			WalkingSound.stop()
		else:
			FlyingSound.stop()
			if is_on_floor() and (abs(velocity.x) > 0.1 or abs(velocity.z) > 0.1):
				if not WalkingSound.playing:
					WalkingSound.play()
			else:
				WalkingSound.stop()

func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion):
		# rotate camera
		var _yaw := 0.0
		var _pitch := 0.0

		_yaw = -event.screen_relative.x * CAMERA_SENSITIVITY
		_pitch = -event.screen_relative.y * CAMERA_SENSITIVITY

		# TwistPivot.rotate_y(_yaw);
		# PitchPivot.rotate_x(_pitch);

		_target_camera_yaw += _yaw;
		if not is_on_floor():
				_target_camera_pitch += _pitch
		else:
				_target_camera_pitch = deg_to_rad(-15)


func _on_eat_pressed(delta: float):
	print("eat")
	GameState.food += 10 * delta
