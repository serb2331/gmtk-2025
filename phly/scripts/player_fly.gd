extends CharacterBody3D

const ACCELERATION = 8
const MAX_SPEED = 1
var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var CameraSpringArm := $CameraSpringArm
@onready var Camera := $CameraSpringArm/Camera
const MOUSE_SENSITIVITY = 0.01
const YAW_THRESHOLD = deg_to_rad(0.5)

@onready var Model : Node3D = $FlyModel

@onready var animation_tree: AnimationTree = $FlyModel/AnimationTree
@onready var FlyAnimation : AnimationPlayer = $FlyModel/AnimationPlayer

@onready var FlyingSound : AudioStreamPlayer = $FlyingSound
@onready var WalkingSound : AudioStreamPlayer = $WalkingSound
@onready var Swatter : Node3D = $Swatter
@onready var swatter_animation: AnimationPlayer = $Swatter/Hand_Rig/AnimationPlayer
const CAMERA_SENSITIVITY = 0.01


var _true_model_yaw := 0.0
var _true_model_pitch := 0.0
var _last_camera_yaw := 0.0

var is_in_swatter_animation
	
const CAMERA_PITCH_OFFSET = deg_to_rad(30);
const CAMERA_YAW_OFFSET = deg_to_rad(180);

func _rotateCamera() -> void:
	CameraSpringArm.rotation.x = lerp_angle(CameraSpringArm.rotation.x, -(_true_model_pitch + CAMERA_PITCH_OFFSET), 0.1);
	CameraSpringArm.rotation.y = lerp_angle(CameraSpringArm.rotation.y, _true_model_yaw + CAMERA_YAW_OFFSET, 0.1);

func _rotateModel(model) -> void:
	model.rotation.x = _true_model_pitch;
	model.rotation.y = _true_model_yaw;

func _handleMovement(delta) -> void:

	var _is_moving := false;
	var _move_direction := Vector3.ZERO;	

	# Move forward (W) — horizontal plane only
	if Input.is_action_pressed("move_forward"):
		_move_direction += Model.global_transform.basis.z
		_is_moving = true;

	if Input.is_action_pressed("move_back"):
		_move_direction -= Model.global_transform.basis.z
		_is_moving = true;

	if Input.is_action_pressed("fly"):
		_move_direction += Model.global_transform.basis.y
		_is_moving = true;

	###############

	velocity = lerp(velocity, Vector3.ZERO, 0.1);

	if (_is_moving):
		velocity += _move_direction.normalized() * ACCELERATION * delta;
	else:
		if (!is_on_floor()):
			velocity += Vector3.DOWN * GRAVITY * delta;

	print(velocity.length())

	velocity.limit_length(MAX_SPEED);
	if not GameState.is_caught_in_web:
		move_and_slide()

func _decideAndApplyAnimation() -> void:
	var yaw_diff = _true_model_yaw - _last_camera_yaw
	_last_camera_yaw = _true_model_yaw

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
	_last_camera_yaw = _true_model_yaw
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Swatter.visible = false
	is_in_swatter_animation = false
	Swatter.animation_finished.connect(swatter_animation_finished)
	
func swatter_animation_finished():
	print("animation finished 2!")
	if GameState.inside_food:
		GameState.handle_death()
	is_in_swatter_animation = false

func _physics_process(delta: float) -> void:
	if !GameState.is_respawning && !GameState.is_dying:
		if is_on_floor():
			_true_model_pitch = 0

		_rotateCamera()
		_rotateModel(Model)
		_rotateModel(Swatter)

		_handleMovement(delta);
		_decideAndApplyAnimation();	
		if GameState.inside_food:
			if not is_in_swatter_animation:
				Swatter.start_swatter_animation()
			if Input.is_action_pressed("eat"):
				_on_eat_pressed(delta)
		else:
			is_in_swatter_animation = false
			Swatter.stop_swatter_animation()
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
		# print(event.screen_relative)

		# rotate camera
		var _yaw := 0.0
		var _pitch := 0.0

		_yaw = -event.relative.x * MOUSE_SENSITIVITY
		_pitch = -event.relative.y * MOUSE_SENSITIVITY

		# print(_yaw, " ---- ", _pitch);

		_true_model_yaw += _yaw;
		if not is_on_floor():
			_true_model_pitch -= _pitch
		else:
			_true_model_pitch = deg_to_rad(0)

func _process(delta):
	var right_stick_x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	var right_stick_y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	
	if abs(right_stick_x) > 0.1 or abs(right_stick_y) > 0.1:
		var _yaw = -right_stick_x * MOUSE_SENSITIVITY * 200 * delta
		var _pitch = -right_stick_y * MOUSE_SENSITIVITY * 200 * delta
		
		_true_model_yaw += _yaw
		if not is_on_floor():
			_true_model_pitch += _pitch
		else:
			_true_model_pitch = deg_to_rad(-15)
	
	if is_on_floor() and _true_model_pitch != deg_to_rad(-15):
		_true_model_pitch = deg_to_rad(-15)


func _on_eat_pressed(delta: float):
	print("eat")
	GameState.food += 10 * delta


func _on_kill_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemies"):
		print("killed by spider!")
		GameState.handle_death()
