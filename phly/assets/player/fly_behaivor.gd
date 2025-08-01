extends Node3D

@export var animation_player: AnimationPlayer

func _ready():
    var idle_animation = load("res://path/to/my_animation.res")
    animation_player.add_animation("idle", idle_animation)
    animation_player.play("idle")