extends Label

@export var player_fly: CharacterBody3D

const DECREMENT_INTERVAL = 1.0
var cooldown
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cooldown = 1.0
	text = str(GameState.initialize_health())
	pass # Replace with function body.

func decrement_health_every_second(delta: float):
	cooldown -= delta
	if cooldown <= 0:
		GameState.decrement_health()
		cooldown = DECREMENT_INTERVAL

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	decrement_health_every_second(delta)
	text = str(GameState.health)
		
