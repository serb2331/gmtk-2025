extends Node

var parent: Node3D
var food_scene: PackedScene
var list_of_food: Array

const MIN_FOOD_DISTANCE = 0.3
const EDGE_OFFSET = 0.2
const FOOD_COUNT = 2

const table1 = [
	Vector3(-1.438, 0.843, 0.198),
	Vector3(-1.438, 0.843, -0.418),
	Vector3(-1.062, 0.843, -0.418),
	Vector3(-1.062, 0.843, 0.198)
]
const table2 = [
	Vector3(-1.512, 0.843, -0.607),
	Vector3(-1.512, 0.843, -1.233),
	Vector3(-1.071, 0.843, -1.233),
	Vector3(-1.071, 0.843, -0.616)
]
const corner_table = [
	Vector3(-1.071, 0.849, -1.489),
	Vector3(-1.012, 0.849, -1.92),
	Vector3(-1.473, 0.849, -1.92),
	Vector3(-1.473, 0.849, -1.427)
]
const window_table = [
	Vector3(-0.768, 0.857, -1.927),
	Vector3(-0.768, 0.857, -1.492),
	Vector3(-0.154, 0.857, -1.492),
	Vector3(-0.154, 0.857, -1.828)
]
const shelf_up = [
	Vector3(-1.46, 1.656, -0.226),
	Vector3(-1.46, 1.656, -0.858),
	Vector3(-1.304, 1.656, -0.858),
	Vector3(-1.304, 1.656, -0.18),
]
const floor1 = [
	Vector3(-0.741, -0.014, -1.03),
	Vector3(-0.271, -0.014, -1.03),
	Vector3(-0.104, -0.014, 0.185),
	Vector3(-0.93, -0.014, 0.185),
]
const round_table = [
	Vector3(1.025, 0.761, -0.113),
	Vector3(0.619, 0.761, -0.285),
	Vector3(0.708, 0.761, -0.661),
	Vector3(0.9, 0.761, -0.661),
]
const double_shelf_1 = [
	Vector3(0.67, 1.89, 0.812),
	Vector3(0.67, 1.89, 1.204),
	Vector3(0.521, 1.89, 1.204),
	Vector3(0.521, 1.89, 0.764),
]
const PLANES_TO_GENERATE_ON = [
	table1,
	table2,
	corner_table,
	window_table,
	shelf_up,
	floor1,
	round_table,
	double_shelf_1
]

func get_random_food() -> Node:
	var food_scenes = [
		load("res://assets/environment/food_items/SM_Apple.fbx"),
		load("res://assets/environment/food_items/SM_Banana.fbx"),
		load("res://assets/environment/food_items/SM_Spilled_Bottle.fbx"),
		load("res://assets/environment/food_items/SM_Bread.fbx"),
		load("res://assets/environment/food_items/SM_Pizza.fbx"),
		load("res://assets/environment/food_items/SM_Pot.fbx")
	]
	var random_scene = food_scenes.pick_random()
	return random_scene.instantiate()

func random_point_on_plane(plane: Array, offset: float = 0.0) -> Vector3:
	var p0 = plane[0]
	var p1 = plane[1]
	var p2 = plane[2]
	var p3 = plane[3]
	var dir01 = (p1 - p0).normalized()
	var dir03 = (p3 - p0).normalized()
	var dir21 = (p1 - p2).normalized()
	var dir23 = (p3 - p2).normalized()

	var p0i = p0 + dir01 * offset + dir03 * offset
	var p1i = p1 - dir01 * offset + dir21 * offset
	var p2i = p2 - dir21 * offset - dir23 * offset
	var p3i = p3 + dir23 * offset - dir03 * offset

	var u = randf()
	var v = randf()
	if u + v > 1.0:
		u = 1.0 - u
		v = 1.0 - v
	var a = p0i.lerp(p1i, u)
	var b = p3i.lerp(p2i, u)
	return a.lerp(b, v)

func is_position_free(pos: Vector3, parent: Node) -> bool:
	for child in parent.get_children():
		if child is Node3D and child.has_method("set_size"):
			if child.global_transform.origin.distance_to(pos) < MIN_FOOD_DISTANCE:
				return false
	return true

func generate_food():
	var max_attempts = 20
	for i in range(FOOD_COUNT):
		var placed = false
		for attempt in range(max_attempts):
			var plane = PLANES_TO_GENERATE_ON[randi() % PLANES_TO_GENERATE_ON.size()]
			var pos = random_point_on_plane(plane)
			if is_position_free(pos, parent):
				var food = food_scene.instantiate()
				var food_type = get_random_food()
				food.set_type(food_type)
				print(food.name)
				food.global_transform.origin = pos
				if food.has_method("set_size"):
					food.set_size(randi_range(1, 5))
				parent.add_child(food)
				list_of_food.append(food)
				placed = true
				break

func remove_all_food():
	for child in list_of_food:
			child.queue_free()
	list_of_food.clear()	
		
func set_food_props(parentNode: Node, food: PackedScene):
	parent = parentNode
	food_scene = food
