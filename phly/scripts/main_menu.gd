extends Control

@onready var button_hover = $ButtonHoverSound
@onready var button_click = $ButtonClickSound
@onready var CreditsPanel = $CreditsPanelButton
@onready var HowToPlayPanel = $HowToPlayPanelButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CreditsPanel.visible=false
	HowToPlayPanel.visible=false
	
func testEsc():
	if Input.is_action_just_pressed("Escape"):
		CreditsPanel.visible=false
		HowToPlayPanel.visible=false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	testEsc()


func _on_button_pressed() -> void:
	button_click.play()
	GameState.start_game()


func _on_exit_button_pressed() -> void:
	button_click.play()
	get_tree().quit()


func _on_options_button_pressed() -> void:
	print("opening how to play")
	HowToPlayPanel.visible=true


func _on_credits_button_pressed() -> void:
	CreditsPanel.visible=true


func _on_mouse_entered() -> void:
	button_hover.play()


func _on_how_to_play_button_pressed() -> void:
	HowToPlayPanel.visible=false


func _on_credits_panel_button_pressed() -> void:
	CreditsPanel.visible=false
