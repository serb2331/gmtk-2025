extends Node3D

@export var animation_player: AnimationPlayer

func _ready():
	var idle_animation = load("res://assets/player/anim/A_Idle.res")
	var walking_animation = load("res://assets/player/anim/A_Walk_Forward.res")
	var walking_left = load("res://assets/player/anim/A_Walk_Left.res")
	var walking_right = load("res://assets/player/anim/A_Walk_Right.res")
	var flying_animation = load("res://assets/player/anim/A_Flying.res")
	
	if not animation_player.has_animation_library(""):
		animation_player.add_animation_library("", AnimationLibrary.new())
	
	animation_player.get_animation_library("").add_animation("idle", idle_animation)
	animation_player.get_animation_library("").add_animation("walk", walking_animation)
	animation_player.get_animation_library("").add_animation("walk_left", walking_left)
	animation_player.get_animation_library("").add_animation("walk_right", walking_right)
	animation_player.get_animation_library("").add_animation("fly", flying_animation)
	
	animation_player.play("idle")
