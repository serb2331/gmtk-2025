extends Node3D

@export var food_scene: PackedScene  
@export var spider_scene: PackedScene 


func _ready():
	FoodGenerator.generate_food(self, food_scene)
	SpiderGenerator.generate_spiders(self, spider_scene)
