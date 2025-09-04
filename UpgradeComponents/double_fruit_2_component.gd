extends Node

var riping_fruit_component_scene = load("res://MapElements/FruitElements/riping_component.tscn")
var map: Map
var counter := 0

func _ready() -> void:
	map = get_parent()
	#turn present ghost fruits into riping fruits
	for map_fruit in map.find_all_fruits():
		if map_fruit.is_in_group("Ghost Fruit") and not map_fruit.is_riping_fruit:
			var riping_fruit_component = riping_fruit_component_scene.instantiate()
			map_fruit.add_child(riping_fruit_component)
	
	SignalBus.fruit_collected.connect(_on_fruit_collected)
	SignalBus.ghost_fruit_spawned.connect(turn_ghost_fruit_riping)

func _on_fruit_collected(fruit: FruitElement, real_collection: bool):
	if real_collection and not fruit.is_in_group("Ghost Fruit"):
		counter += 1
		if counter % 3 == 0:
			map.spawn_ghost_fruit([])

func turn_ghost_fruit_riping(fruit):
	if not fruit.is_riping_fruit:
		var riping_fruit_component = riping_fruit_component_scene.instantiate()
		fruit.add_child(riping_fruit_component)

func self_destruct():
	queue_free()
