extends Node3D

signal animation_finised

func _ready()-> void:
	var animation = $AnimationPlayer.get_animation("swatter_anim/A_Hand_Swat")
	animation.loop_mode = Animation.LOOP_NONE

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "swatter_anim/A_Hand_Swat":
		print("animation finished!")
		emit_signal("animation_finised")
