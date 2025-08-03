extends Control


@onready var name_label = $NameLabel
func update_name_label():
	name = "Phly"
	for i in range(1,GameState.number_of_generations_survived):
		name += " Jr"
	name_label.text = name
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.respawned.connect(update_name_label)
