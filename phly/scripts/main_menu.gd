extends Control

@onready var button_hover = $ButtonHoverSound
@onready var button_click = $ButtonClickSound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	button_click.play()
	GameState.start_game()


func _on_exit_button_pressed() -> void:
	button_click.play()
	get_tree().quit()


func _on_options_button_pressed() -> void:
	print("opening options")
	pass # Replace with function body.


func _on_credits_button_pressed() -> void:
	pass # Replace with function body.


func _on_mouse_entered() -> void:
	button_hover.play()
