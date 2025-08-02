extends CharacterBody3D

var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")
const IDLE_STATE = 1
const PURSUING_STATE = 2


var player: Node3D = null
var speed = 0.3
var spider_state

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spider_state = IDLE_STATE

func move_from_to(from_pos: Vector3, to_pos: Vector3) -> Vector3:
	return (to_pos - from_pos).normalized()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity.y -= GRAVITY * delta
	if player != null and spider_state == PURSUING_STATE:
		var player_pos = player.global_transform.origin
		print("Player position: ", player_pos)
		var direction = move_from_to(global_transform.origin, player.global_transform.origin)
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	velocity.y -= GRAVITY * delta
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	spider_state = PURSUING_STATE
	print(body)
	if body.name == "Player":
		player = body
	print("eneterd spider teritory")


func _on_area_3d_body_exited(body: Node3D) -> void:
	print("exited spider teritory")
	spider_state = IDLE_STATE
