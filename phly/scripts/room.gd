extends Node3D

@export var food_scene: PackedScene  


func _ready():
	FoodGenerator.generate_food(self, food_scene)
