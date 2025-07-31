extends Node

const MIN_FOOD_DISTANCE = 0.2

const table1 = [
		Vector3(-1.568, 0.943, 1.348),
		Vector3(-1.568, 0.943, 0.732),
		Vector3(-1.192, 0.943, 0.732),
		Vector3(-1.192, 0.943, 1.348)
	]
const table2 = [
	Vector3(-1.642, 0.943, 0.543),   
	Vector3(-1.642, 0.943, -0.083),   
	Vector3(-1.201, 0.943, -0.083),   
	Vector3(-1.201, 0.943, 0.534),   
]
const corner_table =  [
	Vector3(-1.201, 0.949, -0.339),   
	Vector3(-1.142, 0.949, -0.77),   
	Vector3(-1.603, 0.949, -0.77),   
	Vector3(-1.603, 0.949, -0.277),   
]
const window_table = [
	Vector3(-0.898, 0.957, -0.777),   
	Vector3(-0.898, 0.957, -0.342),   
	Vector3(-0.284, 0.957, -0.342),   
	Vector3(-0.284, 0.957, -0.678),   
]
const PLANES_TO_GENERATE_ON = [
	table1,
	table2,
	corner_table,
	window_table
]

const FOOD_COUNT = 10

func random_point_on_plane(plane: Array) -> Vector3:
	var u = randf()
	var v = randf()
	if u + v > 1.0:
		u = 1.0 - u
		v = 1.0 - v
	var p0 = plane[0]
	var p1 = plane[1]
	var p2 = plane[2]
	var p3 = plane[3]
	var a = p0.lerp(p1, u)
	var b = p3.lerp(p2, u)
	return a.lerp(b, v)

func is_position_free(pos: Vector3, parent: Node) -> bool:
	for child in parent.get_children():
		if child is Node3D and child.has_method("set_size"):
			if child.global_transform.origin.distance_to(pos) < MIN_FOOD_DISTANCE:
				return false
	return true

func generate_food(parent: Node, food_scene: PackedScene):
	var max_attempts = 20
	for i in range(FOOD_COUNT):
		var placed = false
		for attempt in range(max_attempts):
			var plane = PLANES_TO_GENERATE_ON[randi() % PLANES_TO_GENERATE_ON.size()]
			var pos = random_point_on_plane(plane)
			if is_position_free(pos, parent):
				var food = food_scene.instantiate()
				food.global_transform.origin = pos
				if food.has_method("set_size"):
					food.set_size(randi_range(1, 5))
				parent.add_child(food)
				placed = true
				break