extends Panel


var FIND_FOOD_OBJECTIVE_TEXT = "Objective | Find food to gain energy"
var EAT_FOOD_OBJECTIVE_TEXT = "Objective | Press Z to eat food"
var REPRODUCE_OBJECTIVE_TEXT = "Objective | Press X to lay egg"

@onready var label = $Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameState.can_respawn:
		self.visible = false
	else:
		self.visible = true
	
	if GameState.can_lay_egg():
		label.text = REPRODUCE_OBJECTIVE_TEXT
	elif GameState.inside_food:
		label.text = EAT_FOOD_OBJECTIVE_TEXT
	else:
		label.text = FIND_FOOD_OBJECTIVE_TEXT
