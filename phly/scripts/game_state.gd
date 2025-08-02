extends Node


var health: int
var score: int
var food: int
const DECREMENT_VALUE = 1.0
const STARTING_FOOD = 0
const starting_health_options := [100,50,80,120]
const MIN_HEALTH = 0
const has_descendant = false

func initialize_health():
	health = starting_health_options[randi() % starting_health_options.size()]
	return health
	
func decrement_health():
	health -= DECREMENT_VALUE
	if health <= MIN_HEALTH:
		if !has_descendant:
			handle_death()
		else:
			print("respawn")
	
func start_game():
	print("starting game")
	get_tree().change_scene_to_file("res://room.tscn")
	
func handle_death():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://scenes/end_game_screen.tscn")
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
