extends Node3D

func _on_area_3d_body_entered(body:Node3D) -> void:
    print("Something entered the area:", body)
    
    if body.has_method("on_area_entered"):
        body.on_area_entered(self)
