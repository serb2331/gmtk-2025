extends Control


func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func testEsc():
	if Input.is_action_just_pressed("Escape"):
		print("pressed")
		if get_tree().paused:
			resume()
		else:
			pause()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("RESET")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	testEsc()


func _on_resume_button_pressed() -> void:
	resume()
	$Panel/MarginContainer/VBoxContainer/ResumeButton.release_focus()


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	$Panel/MarginContainer/VBoxContainer/ResumeButton.release_focus()
	get_tree().reload_current_scene()


func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
