extends VideoStreamPlayer

var was_respawning = false

func _process(_delta):
	if true and not was_respawning:
		was_respawning = true
		stream = load("res://assets/cutscenes/Respawn.mp4")
		play()
	elif not GameState.is_respawning and was_respawning:
		was_respawning = false
