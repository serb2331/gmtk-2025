extends Node3D

@export var animation_player: AnimationPlayer
@export var animation_tree: AnimationTree

func _ready():
	var idle_animation = load("res://assets/player/anim/A_Idle.res")
	var walking_animation = load("res://assets/player/anim/A_Walk_Forward.res")
	var walking_left = load("res://assets/player/anim/A_Walk_Left.res")
	var walking_right = load("res://assets/player/anim/A_Walk_Right.res")
	
	if not animation_player.has_animation_library(""):
		animation_player.add_animation_library("", AnimationLibrary.new())
	
	animation_player.get_animation_library("").add_animation("idle", idle_animation)
	animation_player.get_animation_library("").add_animation("walk", walking_animation)
	animation_player.get_animation_library("").add_animation("walk_left", walking_left)
	animation_player.get_animation_library("").add_animation("walk_right", walking_right)
	
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

	state_machine.get_node("idle").animation = "idle"
	state_machine.get_node("walk").animation = "walk"
	state_machine.get_node("walk_left").animation = "walk_left"
	state_machine.get_node("walk_right").animation = "walk_right"

	var blend_time = AnimationNodeStateMachineTransition.new()
	blend_time.xfade_time = 0.2
	state_machine.add_transition("idle", "walk",blend_time)
	state_machine.add_transition("walk", "idle", blend_time)
	state_machine.add_transition("walk", "walk_left", blend_time)
	state_machine.add_transition("walk", "walk_right", blend_time)
	state_machine.add_transition("walk_left", "walk", blend_time)
	state_machine.add_transition("walk_right", "walk", blend_time)

	animation_tree.set("parameters/playback", NodePath("parameters/playback"))
