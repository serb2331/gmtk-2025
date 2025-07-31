extends Node3D

var size: int = 1

func set_size(new_size: int) -> void:
    size = new_size
    
func decrease_size(amount: int = 1) -> void:
    size -= amount
    print("Food size is now:", size)
    if size <= 0:
        queue_free()  


func _on_area_3d_body_entered(body:Node3D) -> void:
    print("Something entered the area:", body)
    
    if body.has_method("on_area_entered"):
        body.on_area_entered(self)