extends Node

signal respawned
signal play_wohoo
signal play_respawn

var player: CharacterBody3D
var health: int
var score: int
var food: float
var needed_food: float
var inside_food: bool
var can_respawn: bool
var is_respawning: bool
var is_dying: bool
var respawn_location: Vector3
var is_caught_in_web: bool
var number_of_generations_survived: int
var room: Node3D
var last_egg: Node3D


const DECREMENT_VALUE = 1.0
const STARTING_FOOD = 0
const starting_health_options := [25,50,40,60]
const starting_food_options := [0,20,0,5,15]
const respawning_treshold := [60,80,90,80]
const MIN_HEALTH = 0
const has_descendant = false
var death_sound: AudioStreamPlayer

func set_room(room_scene: Node3D):
	room = room_scene

func initialize_health():
	health = starting_health_options[randi() % starting_health_options.size()]
	return health
	
func initialize_food():
	can_respawn = false
	is_respawning = false
	food = starting_food_options[randi() % starting_food_options.size()]
	needed_food = respawning_treshold[randi() % respawning_treshold.size()]
	return food

func can_lay_egg():
	return food > needed_food

func set_respawn(location):
	if is_respawning:
		return
	if can_lay_egg()	:
		emit_signal("play_wohoo")
		can_respawn = true
		is_respawning = true
		food -= needed_food
		await get_tree().create_timer(2.0).timeout
		respawn_location = location
		var egg_scene = load("res://assets/player/sm_egg.tscn")
		if egg_scene:
			remove_egg()
			var egg = egg_scene.instantiate()
			egg.global_transform.origin = location
			room.add_child(egg)
			last_egg = egg
		is_respawning = false

func remove_egg():
	if last_egg:
		last_egg.queue_free()

func decrement_health():
	health -= DECREMENT_VALUE
	if health <= MIN_HEALTH:
		handle_death()
	
func start_game():
	print("starting game")
	number_of_generations_survived = 1
	is_caught_in_web = false
	get_tree().change_scene_to_file("res://scenes/room.tscn")
	
func handle_death():
	if is_dying:
		return
	if can_respawn:
		is_dying = true
		if death_sound:
			death_sound.play()
		await get_tree().create_timer(2.0).timeout
		emit_signal("play_respawn")
		initialize_health()
		initialize_food()
		player.global_position = respawn_location
		is_dying = false
		is_caught_in_web = false
		FoodGenerator.remove_all_food()
		FoodGenerator.generate_food()
		remove_egg()
		number_of_generations_survived += 1
		emit_signal("respawned")
	else:
		if death_sound:
			death_sound.play()
		FoodGenerator.generate_food()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		remove_egg()
		get_tree().change_scene_to_file("res://scenes/end_game_screen.tscn")
	

func _ready() -> void:
	var death_audio = load("res://assets/music/fly/death.wav")
	death_sound = AudioStreamPlayer.new()
	death_sound.stream = death_audio
	death_sound.volume_db = -2.0
	add_child(death_sound)


func _process(delta: float) -> void:
	pass
