extends Node

var swiss_knive = false
var map:Map
var snake_tail:SnakeTail
var already_cut: bool = false

var cuttable_area = 3

func _ready() -> void:
	map = get_parent()
	snake_tail = map.snake_tail
	map.snake_head.cut.connect(_cuttable_tail_hit)
	SignalBus.pre_next_tile_reached.connect(_make_bodyparts_cuttable)
	SignalBus.round_started.connect(_reset_already_cut)
	SignalBus.swiss_knive_synergy.connect(_set_swiss_knive)

func _set_swiss_knive(state:bool):
	swiss_knive = state
	if swiss_knive:
		cuttable_area = 6
	else:
		cuttable_area = 3

func _cuttable_tail_hit(colliding_element):
	var body_parts:Array[SnakeBody] = map.snake_path_bodyparts
	var index = body_parts.find(colliding_element.get_parent())
	if index == 0:
		return
	for i in range(index):
		var body = map.snake_path_bodyparts.pop_front()
		body.queue_free()
		var direction = map.snake_path_directions.pop_front()
		SignalBus.tail_skip.emit()
	await get_tree().process_frame
	already_cut = true
	snake_tail.teleport_destination = TileHelper.position_to_tile(map.snake_path_bodyparts[0].position)

func _make_bodyparts_cuttable():
	if already_cut:
		return
	var body_parts:Array[SnakeBody] = map.snake_path_bodyparts
	
	if body_parts.size() <= cuttable_area:
		return
	#turn off every collision layer
	body_parts[cuttable_area].solid_element.collision_layer = 0
	body_parts[cuttable_area].solid_element.set_collision_layer_value(9,true)
	#set look
	if body_parts[cuttable_area].frame == 0:
		body_parts[cuttable_area].frame = 3
	else:
		body_parts[cuttable_area].frame = 4

func _reset_already_cut():
	already_cut = false
		
func self_destruct():
	for bodypart in map.snake_path_bodyparts:
		bodypart.solid_element.set_collision_layer_value(9,false)
		if bodypart.frame == 3:
			bodypart.frame = 0
		elif bodypart.frame == 4:
			bodypart.frame = 1
	queue_free()
	
