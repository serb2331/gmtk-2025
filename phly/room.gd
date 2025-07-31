extends Node3D

@export var food_scene: PackedScene  

func _ready():
	for i in range(10): 
		var food = food_scene.instantiate()
		food.global_transform.origin = Vector3(
			randf_range(-10, 10),
			0,
			randf_range(-10, 10)
		)
		if food.has_method("set_size"):
			food.set_size(randi_range(1, 5))
		add_child(food)
