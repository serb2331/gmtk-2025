extends Node


var health: int
var score: int
const DECREMENT_VALUE = 1.0
const starting_health_options := [100,50,80,120]

func initialize_health():
	health = starting_health_options[randi() % starting_health_options.size()]
	return health
	
func decrement_health():
	health -= DECREMENT_VALUE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
