extends Node3D

@export var food_scene: PackedScene  
@export var spider_scene: PackedScene 


func _ready():
	FoodGenerator.set_food_props(self, food_scene)
	FoodGenerator.generate_food()
	SpiderGenerator.generate_spiders(self, spider_scene)
