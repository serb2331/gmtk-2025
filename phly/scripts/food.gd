extends Node3D

var size: int = 1

func set_size(new_size: int) -> void:
	size = new_size

func set_type(food_instance: Node) -> void:
	var mesh_node: MeshInstance3D = null
	for child in food_instance.get_children():
		if child is MeshInstance3D:
			mesh_node = child
			break

	if mesh_node:
		var my_mesh: MeshInstance3D = null
		for child in get_children():
			if child is MeshInstance3D:
				my_mesh = child
				break
				
		if my_mesh:
			my_mesh.mesh = mesh_node.mesh
			my_mesh.scale = Vector3(0.01, 0.01, 0.01)
			var random_y = randf_range(0.0, TAU) 
			my_mesh.rotation.y = random_y

			var static_body = StaticBody3D.new()
			static_body.name = "StaticBody3D"
			add_child(static_body)

			var collision_shape = CollisionShape3D.new()
			static_body.add_child(collision_shape)

			collision_shape.shape = my_mesh.mesh.create_trimesh_shape()
			static_body.transform = my_mesh.transform
		else:
			print("No MeshInstance3D found in this scene")
	else:
		print("Could not find MeshInstance3D in SM_Apple.fbx")
	
func decrease_size(amount: int = 1) -> void:
	size -= amount
	print("Food size is now:", size)
	if size <= 0:
		queue_free()  


func _on_area_3d_body_entered(body:Node3D) -> void:
	print("Something entered the area:", body)
	
	if body.has_method("on_area_entered"):
		body.on_area_entered(self)
