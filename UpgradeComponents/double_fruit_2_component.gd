extends Node

var riping_fruit_scene = load("res://MapElements/FruitElements/riping_fruit_element.tscn")

func _ready() -> void:
	var fruits: Array[MapElement] = get_parent().find_all_fruits()
	for fruit in fruits:
		var pos = fruit.position
		fruit.queue_free()
		var riping_fruit = riping_fruit_scene.instantiate()
		get_parent().add_child(riping_fruit)
		riping_fruit.position = pos
		
	get_parent().fruit_element_scene = riping_fruit_scene
	var forbidden_tiles : Array[Vector2i] = []
	get_parent().spawn_fruit(forbidden_tiles)

func self_destruct():
	get_parent().find_all_fruits()[0].queue_free()
	get_parent().fruit_element_scene = load("res://MapElements/FruitElements/fruit_element.tscn")
	queue_free()
