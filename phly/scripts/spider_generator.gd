extends Node


const spider_spots = [
	Vector3(0.381, 0.907, 1.712),
	Vector3(0.872, 0.81, -0.305),
	Vector3(0.381, 0.907, 1.712),
	Vector3(-1.366, 0.907, -1.676),
]

const number_of_spiders = 2

func get_random_spider_position():
	return spider_spots.pick_random()
	

func generate_spiders(parent: Node, spider_scene: PackedScene):
	var max_attempts = 20
	var list_of_spider_spots = []
	
	for i in range(number_of_spiders):
		var placed = false
		for attempt in range(max_attempts):
			var pos = get_random_spider_position()
			if pos not in list_of_spider_spots:
				var spider = spider_scene.instantiate()
				spider.global_transform.origin = pos
				parent.add_child(spider)
				placed = true
				list_of_spider_spots.append(pos)
				break
