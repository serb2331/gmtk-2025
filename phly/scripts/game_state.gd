extends Node

var health: int
var score: int
var food: float
var needed_food: float
var inside_food: bool
var can_respawn: bool
var is_respawning: bool
var respawn_location: Vector3

const DECREMENT_VALUE = 1.0
const STARTING_FOOD = 0
const starting_health_options := [100,50,80,120]
const starting_food_options := [0,20,0,5,15]
const respawning_treshold := [60,80,90,10]
const MIN_HEALTH = 0
const has_descendant = false
var death_sound: AudioStreamPlayer

func initialize_health():
	health = starting_health_options[randi() % starting_health_options.size()]
	return health
	
func initialize_food():
	can_respawn = false
	is_respawning = false
	food = starting_food_options[randi() % starting_food_options.size()]
	needed_food = respawning_treshold[randi() % respawning_treshold.size()]
	return food

func set_respawn(location):
	if food > needed_food:
		food -= needed_food
		respawn_location = location
		can_respawn = true

func decrement_health():
	health -= DECREMENT_VALUE
	if health <= MIN_HEALTH:
		if !has_descendant:
			handle_death()
		else:
			print("respawn")
	
func start_game():
	print("starting game")
	get_tree().change_scene_to_file("res://scenes/room.tscn")
	
func handle_death():
	if death_sound:
		death_sound.play()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://scenes/end_game_screen.tscn")
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var death_audio = load("res://assets/music/fly/death.wav")
	death_sound = AudioStreamPlayer.new()
	death_sound.stream = death_audio
	death_sound.volume_db = -2.0
	add_child(death_sound)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
