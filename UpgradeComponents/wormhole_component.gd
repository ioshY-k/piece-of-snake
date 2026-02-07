extends ActiveItemBase

signal item_deactivated
var button_held: bool = false

const TILE_SELECT_CURSOR = preload("res://UpgradeComponents/WormHole/tile_select_cursor.tscn")
const teleport_element_scene = preload("res://MapElements/TeleportElement/teleport_element.tscn")
@onready var active_item_ui: AnimatedSprite2D = $ActiveItemUI

var tile_select_cursor: Sprite2D
var current_teleporters: Array[Teleporter] = []
var current_map: Map
var local_cursor_position

func _ready() -> void:
	super._ready()
	active_item_slot = get_parent()
	show_behind_parent = true
	item_activated.connect(_on_item_activated)
	item_deactivated.connect(_on_item_deactivated)
	item_activated.connect(active_item_slot._on_item_activated.bind())
	SignalBus.teleport_finished.connect(_on_teleport_finished)
	SignalBus.round_started.connect(_set_UI)

func _set_UI():
	if uses == 2:
		active_item_ui.frame = 0
	elif uses == 4:
		active_item_ui.frame = 1
	elif uses == 6:
		active_item_ui.frame = 2


func _process(delta: float) -> void:
	if Input.is_action_just_pressed(active_item_button) and uses > 0 and not shop_phase and !button_held:
		current_map = active_item_slot.get_parent().current_map
		current_map.process_mode = Node.PROCESS_MODE_DISABLED
		SignalBus.map_paused.emit()
		item_activated.emit(uses-1)
		tile_select_cursor = TILE_SELECT_CURSOR.instantiate()
		active_item_slot.get_parent().add_child(tile_select_cursor)
		await get_tree().process_frame
		local_cursor_position = TileHelper.tile_to_position(TileHelper.position_to_tile(current_map.snake_head.position))
		button_held = true
	if Input.is_action_just_pressed(active_item_button) and button_held:
		button_held = false
		item_deactivated.emit()
		tile_select_cursor.queue_free()
		#uses-1 is the light index for the itembag to go out
		uses -= 1
	if button_held:
		if !GlobalSettings.keyboard_only:
			local_cursor_position = TileHelper.tile_to_position(TileHelper.position_to_tile(current_map.get_local_mouse_position()))
		var upper_left_corner
		var lower_right_corner
		match current_map.zoom_state:
			0:
				upper_left_corner = MapData.get_map_data0(current_map.get_parent().current_map_index)[3]
				lower_right_corner = MapData.get_map_data0(current_map.get_parent().current_map_index)[4]
			1:
				upper_left_corner = MapData.get_map_data1(current_map.get_parent().current_map_index)[3]
				lower_right_corner = MapData.get_map_data1(current_map.get_parent().current_map_index)[4]
			2:
				upper_left_corner = MapData.get_map_data2(current_map.get_parent().current_map_index)[3]
				lower_right_corner = MapData.get_map_data2(current_map.get_parent().current_map_index)[4]
			3:
				upper_left_corner = MapData.get_map_data3(current_map.get_parent().current_map_index)[3]
				lower_right_corner = MapData.get_map_data3(current_map.get_parent().current_map_index)[4]
				
		if GlobalSettings.keyboard_only:
			if Input.is_action_just_pressed("move_up") and TileHelper.position_to_tile(local_cursor_position).y > upper_left_corner.y+1:
				local_cursor_position = TileHelper.get_next_tile(TileHelper.position_to_tile(local_cursor_position),TileHelper.DIRECTION.UP)
				local_cursor_position = TileHelper.tile_to_position(local_cursor_position)
			if Input.is_action_just_pressed("move_right") and TileHelper.position_to_tile(local_cursor_position).x < lower_right_corner.x-1:
				local_cursor_position = TileHelper.get_next_tile(TileHelper.position_to_tile(local_cursor_position),TileHelper.DIRECTION.RIGHT)
				local_cursor_position = TileHelper.tile_to_position(local_cursor_position)
			if Input.is_action_just_pressed("move_down") and TileHelper.position_to_tile(local_cursor_position).y < lower_right_corner.y-1:
				local_cursor_position = TileHelper.get_next_tile(TileHelper.position_to_tile(local_cursor_position),TileHelper.DIRECTION.DOWN)
				local_cursor_position = TileHelper.tile_to_position(local_cursor_position)
			if Input.is_action_just_pressed("move_left") and TileHelper.position_to_tile(local_cursor_position).x > upper_left_corner.x+1:
				local_cursor_position = TileHelper.get_next_tile(TileHelper.position_to_tile(local_cursor_position),TileHelper.DIRECTION.LEFT)
				local_cursor_position = TileHelper.tile_to_position(local_cursor_position)
			tile_select_cursor.global_position = tile_select_cursor.global_position.lerp(current_map.to_global(local_cursor_position), 0.3)
		else:
			if TileHelper.position_to_tile(local_cursor_position).x > upper_left_corner.x and\
			TileHelper.position_to_tile(local_cursor_position).y > upper_left_corner.y and\
			TileHelper.position_to_tile(local_cursor_position).x < lower_right_corner.x and\
			TileHelper.position_to_tile(local_cursor_position).y < lower_right_corner.y:
				tile_select_cursor.global_position = tile_select_cursor.global_position.lerp(current_map.to_global(local_cursor_position),0.3)

func _on_item_activated(_uses):
	active_item_slot.get_parent().time_meter.stop_timer()
	

func _on_item_deactivated():
	var new_teleporter: Teleporter = teleport_element_scene.instantiate()
	new_teleporter.one_use = true
	new_teleporter.destination_tile = TileHelper.position_to_tile(current_map.to_local(tile_select_cursor.global_position))
	current_map.add_child(new_teleporter)
	var teleporter_tile = TileHelper.get_next_tile(current_map.snake_head.next_tile, current_map.snake_head.current_direction)
	new_teleporter.position = TileHelper.tile_to_position(teleporter_tile)
	new_teleporter.rotation_degrees = current_map.snake_head.get_orientation(current_map.snake_head.current_direction, 0.0) + 180
	
	current_map.temporary_obstacles.append(teleporter_tile)
	
	current_teleporters.append(new_teleporter)
	current_map.process_mode = Node.PROCESS_MODE_INHERIT
	SignalBus.map_continued.emit()
	active_item_slot.get_parent().time_meter.continue_timer()
	
	
func _on_teleport_finished(teleporter: Teleporter):
	for tele in current_teleporters:
		if tele == teleporter:
			current_teleporters.erase(tele)
			current_map.temporary_obstacles.erase(TileHelper.position_to_tile(tele.position))

func self_destruct():
	active_item_slot.remove_lights()
	queue_free()
