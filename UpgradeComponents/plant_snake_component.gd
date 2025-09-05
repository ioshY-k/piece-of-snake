extends Sprite2D

var swiss_knive = false
var current_ghost_fruit = null
var map: Map
var fruit_element_scene = load("res://MapElements/FruitElements/fruit_element.tscn")
func _ready() -> void:
	map = get_parent().get_parent()
	SignalBus.got_hit_and_punished.connect(_grow_ghost_fruit)
	SignalBus.fruit_collected.connect(_set_current_ghost_fruit)
	SignalBus.swiss_knive_synergy.connect(_set_swiss_knive)

func _set_swiss_knive(state:bool):
	swiss_knive = state
	if swiss_knive:
		SignalBus.fruit_collected.connect(prevent_growth)
	else:
		if SignalBus.fruit_collected.is_connected(prevent_growth):
			SignalBus.fruit_collected.disconnect(prevent_growth)

func prevent_growth(fruit, is_real_collection):
	if randi()%2 == 0 and fruit != null and fruit.is_in_group("Ghost Fruit") and map.snake_tail.tiles_to_grow > 0:
		map.snake_tail.tiles_to_grow -= 1
	
func _grow_ghost_fruit():
	if current_ghost_fruit != null:
		return
	current_ghost_fruit = fruit_element_scene.instantiate()
	add_child(current_ghost_fruit)
	current_ghost_fruit.add_to_group("Ghost Fruit")
	current_ghost_fruit.fruit_element_sprite.frame = 1
	current_ghost_fruit.position.y = 58
	map.current_fruits.append(current_ghost_fruit)

func _set_current_ghost_fruit(fruit: FruitElement, is_real_collection):
	if fruit == current_ghost_fruit:
		var current_position = fruit.global_position
		fruit.get_parent().remove_child(fruit)
		map.add_child(fruit)
		await get_tree().process_frame
		fruit.global_position = current_position
		current_ghost_fruit = null

func self_destruct():
	queue_free()
