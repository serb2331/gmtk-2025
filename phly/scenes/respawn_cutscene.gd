extends VideoStreamPlayer

func play_cutscene():
	# Show the video (if hidden) and start playing
	visible = true
	play()

	# Wait for it to finish
	await finished

	# Hide it or switch scenes after it ends
	visible = false
	print("Cutscene finished!")
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	GameState.play_respawn.connect(play_cutscene)
