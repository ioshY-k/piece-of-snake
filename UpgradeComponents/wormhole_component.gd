extends ActiveItemBase

signal item_deactivated
var button_held: bool = false

const TILE_SELECT_CURSOR = preload("res://UpgradeComponents/WormHole/tile_select_cursor.tscn")
const teleport_element_scene = preload("res://MapElements/TeleportElement/teleport_element.tscn")
@onready var active_item_ui: AnimatedSprite2D = $ActiveItemUI

var tile_select_cursor: Sprite2D
var current_teleporters: Array[Teleporter] = []
var current_map: Map

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
	if Input.is_action_just_pressed(active_item_button) and uses > 0 and not shop_phase:
		current_map = active_item_slot.get_parent().current_map
		current_map.process_mode = Node.PROCESS_MODE_DISABLED
		button_held = true
		item_activated.emit(uses-1)
		tile_select_cursor = TILE_SELECT_CURSOR.instantiate()
		active_item_slot.get_parent().add_child(tile_select_cursor)
	if Input.is_action_just_released(active_item_button) and button_held:
		button_held = false
		item_deactivated.emit()
		tile_select_cursor.queue_free()
		#uses-1 is the light index for the itembag to go out
		uses -= 1
	if button_held:
		tile_select_cursor.global_position = current_map.to_global( TileHelper.tile_to_position(TileHelper.position_to_tile(current_map.get_local_mouse_position())))
		

func _on_item_activated(_uses):
	active_item_slot.get_parent().time_meter.stop_timer()
	

func _on_item_deactivated():
	var new_teleporter: Teleporter = teleport_element_scene.instantiate()
	new_teleporter.one_use = true
	current_map.add_child(new_teleporter)
	new_teleporter.position = TileHelper.tile_to_position( TileHelper.get_next_tile(current_map.snake_head.next_tile, current_map.snake_head.current_direction))
	new_teleporter.rotation_degrees = current_map.snake_head.get_orientation(current_map.snake_head.current_direction, 0.0) + 180
	new_teleporter.destination_tile = TileHelper.position_to_tile(current_map.to_local(tile_select_cursor.global_position))
	
	current_teleporters.append(new_teleporter)
	current_map.process_mode = Node.PROCESS_MODE_INHERIT
	active_item_slot.get_parent().time_meter.continue_timer()
	
	
func _on_teleport_finished(teleporter: Teleporter):
	for tele in current_teleporters:
		if tele == teleporter:
			current_teleporters.erase(tele)

func self_destruct():
	active_item_slot.remove_lights()
	queue_free()
