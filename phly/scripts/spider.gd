extends CharacterBody3D

var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")
const IDLE_STATE = 1
const PURSUING_STATE = 2

@onready var spider_animation : AnimationPlayer = $Spider/AnimationPlayer
@onready var animation_tree: AnimationTree = $Spider/AnimationTree

var player: Node3D = null
var speed = 0.5
var spider_state

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("enemies")
	spider_state = IDLE_STATE

func move_from_to(from_pos: Vector3, to_pos: Vector3) -> Vector3:
	return (to_pos - from_pos).normalized()
	
func rotate_model(direction):
	var target_rotation = Vector3(0, atan2(direction.x, direction.z), 0)
	rotation.y = lerp_angle(rotation.y, target_rotation.y, 0.1)  
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	var desired_animation := "idle"
	velocity.y -= GRAVITY * delta
	
	if player != null and spider_state == PURSUING_STATE:
		var player_pos = player.global_transform.origin
		print("Player position: ", player_pos)
		var direction = move_from_to(global_transform.origin, player.global_transform.origin)
		rotate_model(direction)
		desired_animation = "walk"
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	velocity.y -= GRAVITY * delta
	
	move_and_slide()
	
	var playback = animation_tree.get("parameters/playback")
	if playback.get_current_node() != desired_animation:
		playback.travel(desired_animation)


func _on_area_3d_body_entered(body: Node3D) -> void:
	spider_state = PURSUING_STATE
	if body.name == "Player":
		player = body
	#print("eneterd spider teritory")


func _on_area_3d_body_exited(body: Node3D) -> void:
	#print("exited spider teritory")
	spider_state = IDLE_STATE
