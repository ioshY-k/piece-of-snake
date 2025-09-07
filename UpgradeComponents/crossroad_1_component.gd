extends ActiveItemBase

var current_map: Map
var small_crossroad_scene = load("res://MapElements/OverlapElement/crossroad_small.tscn")
var big_crossroad_scene = load("res://MapElements/OverlapElement/crossroad_big.tscn")
var big_crossroad: bool = false
@onready var active_item_ui: AnimatedSprite2D = $ActiveItemUI

func _ready() -> void:
	super._ready()
	active_item_slot = get_parent()
	show_behind_parent = true
	for use in range(uses):
		active_item_slot.add_light()
		
	item_activated.connect(_on_item_activated)
	item_activated.connect(active_item_slot._on_item_activated.bind())
	SignalBus.round_started.connect(_set_UI)

func _set_UI():
	if uses == 1 and not big_crossroad:
		active_item_ui.frame = 0
	elif uses == 1 and big_crossroad:
		active_item_ui.frame = 1
	elif uses == 2:
		active_item_ui.frame = 2

func _process(delta: float) -> void:
	if Input.is_action_just_pressed(active_item_button) and uses > 0 and not shop_phase:
		#uses-1 is the light index for the itembag to go out
		item_activated.emit(uses-1)
		uses -= 1

func _on_item_activated(_uses):
	current_map = active_item_slot.get_parent().current_map
	var new_crossroad
	if big_crossroad:
		new_crossroad = big_crossroad_scene.instantiate()
	else:
		new_crossroad = small_crossroad_scene.instantiate()
	current_map.add_child(new_crossroad)
	new_crossroad.position = TileHelper.tile_to_position(current_map.snake_head.next_tile)

func self_destruct():
	active_item_slot.remove_lights()
	queue_free()
