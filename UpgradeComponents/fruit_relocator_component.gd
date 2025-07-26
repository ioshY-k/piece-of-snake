extends ActiveItemBase

var current_map: Map

func _ready() -> void:
	super._ready()
	active_item_slot = get_parent()
	show_behind_parent = true
	for use in range(uses):
		active_item_slot.add_light()
		
	item_activated.connect(_on_item_activated)
	item_activated.connect(active_item_slot._on_item_activated.bind())

func _process(delta: float) -> void:
	if Input.is_action_just_pressed(active_item_button) and uses > 0 and not shop_phase:
		#uses-1 is the light index for the itembag to go out
		item_activated.emit(uses-1)
		uses -= 1

func _on_item_activated(_uses):
	current_map = active_item_slot.get_parent().current_map
	var fruits: Array[MapElement] = current_map.find_all_fruits()
	var fruit_tiles: Array[Vector2i] = []
	for fruit in fruits:
		fruit_tiles.append(TileHelper.position_to_tile(fruit.position))
	
	var surrounding_fruit_tiles: Array[Vector2i] =[]
	for fruit_position in fruit_tiles:
		var x = fruit_position.x - 2
		var y = fruit_position.y -2
		while x <= fruit_position.x + 2:
			while y <= fruit_position.y + 2:
				surrounding_fruit_tiles.append(Vector2i(x,y))
				y += 1
			x += 1
			y = fruit_position.y -2
	
	fruit_tiles.append_array(surrounding_fruit_tiles)
	
				
	for fruit in fruits:
		current_map.spawn_fruit(fruit_tiles)
		current_map.fruit_locations.erase(TileHelper.position_to_tile(fruit.position))
		fruit.queue_free()

func self_destruct():
	active_item_slot.remove_lights()
	queue_free()
