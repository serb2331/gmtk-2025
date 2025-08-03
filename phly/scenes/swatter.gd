extends Node3D

@onready var SwatterRig: Node3D = $Hand_Rig
@onready var swatter_animation: AnimationPlayer = $Hand_Rig/AnimationPlayer

const TIME_BEFORE_ANIMATION_STARTS = 4.0
signal animation_finished

func start_swatter_animation():
	self.visible = true
	await get_tree().create_timer(TIME_BEFORE_ANIMATION_STARTS).timeout
	swatter_animation.play("swatter_anim/A_Hand_Swat")


func stop_swatter_animation():
	self.visible = false
	swatter_animation.play("swatter_anim/none")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SwatterRig.animation_finised.connect(on_animation_finished)

func on_animation_finished():
	emit_signal("animation_finished")
	swatter_animation.seek(0, true)
	swatter_animation.stop()
	self.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
