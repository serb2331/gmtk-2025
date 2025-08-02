extends Control


@onready var generations_label = $Panel/VBoxContainer/GenerationsLabel
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generations_label.text = "Number of generations: "+ str(GameState.number_of_generations_survived)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/room.tscn")
