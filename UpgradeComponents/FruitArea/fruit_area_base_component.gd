class_name FruitAreaBaseComponent extends Node

var map: Map
var current_fruit_area: FruitArea
const FRUIT_AREA = preload("res://UpgradeComponents/FruitArea/fruit_area.tscn")
@onready var next_area_timer: Timer = $NextAreaTimer

func _ready() -> void:
	map = get_parent().current_map
	SignalBus.round_started.connect(_spawn_fruit_area)
	SignalBus.round_over.connect(kill_fruit_area_and_reset_timer)
	next_area_timer.timeout.connect(_spawn_fruit_area)

func _spawn_fruit_area():
	var top_left_bound = MapData.call_map_data_at_zoom(map.zoom_state, map.get_parent().current_map_index)[3]
	var bottom_right_bound = MapData.call_map_data_at_zoom(map.zoom_state, map.get_parent().current_map_index)[4]
	current_fruit_area = FRUIT_AREA.instantiate()
	map.add_child.call_deferred(current_fruit_area)
	await get_tree().process_frame
	var spawning_tile: Vector2i = map.free_map_tiles[randi()%map.free_map_tiles.size()-1]
	var i: int = map.free_map_tiles.size()
	#give it i tries to find a tile that is free and not right at the map border
	while i>0 and\
	(spawning_tile.x == top_left_bound.x+1 or spawning_tile.x == bottom_right_bound.x-1 or\
	spawning_tile.y == top_left_bound.y+1 or spawning_tile.y == bottom_right_bound.y-1):
		spawning_tile = map.free_map_tiles[randi()%map.free_map_tiles.size()-1]
		i-=1
	current_fruit_area.appear(TileHelper.tile_to_position(spawning_tile))
	current_fruit_area.area_left.connect(func():next_area_timer.start())

func kill_fruit_area_and_reset_timer():
	next_area_timer.stop()
	if is_instance_valid(current_fruit_area):
		current_fruit_area.queue_free()

func self_destruct():
	queue_free()
