extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = GameState.initialize_food()
	max_value = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value = GameState.food
