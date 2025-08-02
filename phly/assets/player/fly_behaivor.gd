extends Node3D

@export var animation_player: AnimationPlayer
@export var animation_tree: AnimationTree

func _ready():
	var idle_animation = load("res://assets/player/anim/A_Idle.res")
	var walking_animation = load("res://assets/player/anim/A_Walk_Forward.res")
	var walking_left = load("res://assets/player/anim/A_Walk_Left.res")
	var walking_right = load("res://assets/player/anim/A_Walk_Right.res")
	var flying_animation = load("res://assets/player/anim/A_Flying.res")
	var eating_animation = load("res://assets/player/anim/A_Eating.res")
	var respawn_animation = load("res://assets/player/anim/A_Born.res")
	var death_animation = load("res://assets/player/anim/A_Death.res")
	
	if not animation_player.has_animation_library(""):
		animation_player.add_animation_library("", AnimationLibrary.new())
	
	animation_player.get_animation_library("").add_animation("idle", idle_animation)
	animation_player.get_animation_library("").add_animation("walk", walking_animation)
	animation_player.get_animation_library("").add_animation("walk_left", walking_left)
	animation_player.get_animation_library("").add_animation("walk_right", walking_right)
	animation_player.get_animation_library("").add_animation("fly", flying_animation)
	animation_player.get_animation_library("").add_animation("eat", eating_animation)
	animation_player.get_animation_library("").add_animation("born", respawn_animation)
	animation_player.get_animation_library("").add_animation("die", death_animation)
	
	animation_player.play("idle")

	animation_tree.active = true
	animation_tree.anim_player = animation_player.get_path()
	animation_tree["parameters/playback"].travel("idle")
	
	var state_machine = AnimationNodeStateMachine.new()
	animation_tree.tree_root = state_machine

	state_machine.add_node("idle", AnimationNodeAnimation.new())
	state_machine.add_node("walk", AnimationNodeAnimation.new())
	state_machine.add_node("walk_left", AnimationNodeAnimation.new())
	state_machine.add_node("walk_right", AnimationNodeAnimation.new())
	state_machine.add_node("fly", AnimationNodeAnimation.new())
	state_machine.add_node("eat", AnimationNodeAnimation.new())
	state_machine.add_node("born", AnimationNodeAnimation.new())
	state_machine.add_node("die", AnimationNodeAnimation.new())

	state_machine.get_node("idle").animation = "idle"
	state_machine.get_node("walk").animation = "walk"
	state_machine.get_node("walk_left").animation = "walk_left"
	state_machine.get_node("walk_right").animation = "walk_right"
	state_machine.get_node("fly").animation = "fly"
	state_machine.get_node("eat").animation = "eat"
	state_machine.get_node("born").animation = "born"
	state_machine.get_node("die").animation = "die"

	var blend_time = AnimationNodeStateMachineTransition.new()
	blend_time.xfade_time = 0.2
	state_machine.add_transition("idle", "walk",blend_time)
	state_machine.add_transition("walk", "idle", blend_time)
	state_machine.add_transition("walk", "walk_left", blend_time)
	state_machine.add_transition("walk", "walk_right", blend_time)
	state_machine.add_transition("walk_left", "walk", blend_time)
	state_machine.add_transition("walk_right", "walk", blend_time)
	state_machine.add_transition("idle", "fly", blend_time)
	state_machine.add_transition("fly", "idle", blend_time)
	state_machine.add_transition("walk", "fly", blend_time)
	state_machine.add_transition("fly", "walk", blend_time)
	state_machine.add_transition("walk_left", "fly", blend_time)
	state_machine.add_transition("fly", "walk_left", blend_time)
	state_machine.add_transition("walk_right", "fly", blend_time)
	state_machine.add_transition("fly", "walk_right", blend_time)
	state_machine.add_transition("walk", "eat", blend_time)
	state_machine.add_transition("eat", "walt", blend_time)
	state_machine.add_transition("eat", "idle", blend_time)
	state_machine.add_transition("idle", "eat", blend_time)
	state_machine.add_transition("eat", "fly", blend_time)
	state_machine.add_transition("fly", "eat", blend_time)
	state_machine.add_transition("fly", "born", blend_time)
	state_machine.add_transition("born", "fly", blend_time)
	state_machine.add_transition("born", "idle", blend_time)
	state_machine.add_transition("idle", "born", blend_time)

	state_machine.add_transition("die", "idle", blend_time)
	state_machine.add_transition("idle", "die", blend_time)
	state_machine.add_transition("die", "walk", blend_time)
	state_machine.add_transition("walk", "die", blend_time)
	state_machine.add_transition("die", "eat", blend_time)
	state_machine.add_transition("eat", "die", blend_time)
	state_machine.add_transition("die", "fly", blend_time)
	state_machine.add_transition("fly", "die", blend_time)


	animation_tree.set("parameters/playback", NodePath("parameters/playback"))
