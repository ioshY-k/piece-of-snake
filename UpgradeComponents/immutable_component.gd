extends Node

var map:Map
@onready var immutable_timer: Timer = $ImmutableTimer
var ghost_fruit_counter_max: int = 5
var ghost_fruit_counter_current: int = 5
var halo_scene = load("res://UpgradeComponents/Immutable/immutable_halo.tscn")
var halo
var shop: Shop
const EFFECT_TRIGGER_TEXT = preload("res://UI/effect_trigger_text.tscn")


func _ready() -> void:
	map = get_parent()
	shop = get_parent().get_parent().get_parent().shop
	shop.deal_area_size.position.y += 5000
	SignalBus.round_started.connect(_reset_counter_and_timer)
	immutable_timer.timeout.connect(_spawn_ghost_fruit_upto_5)
	SignalBus.fruit_collected.connect(_prevent_growth_on_5_ghostfruits)
	SignalBus.got_hit.connect(set_halo_frame)
	SignalBus.fruit_collected.connect(set_halo_frame)
	SignalBus.ghost_fruit_spawned.connect(set_halo_frame)
	halo = halo_scene.instantiate()
	map.snake_head.add_child(halo)
	halo.position.y = 36.83
	set_halo_frame()
	
func set_halo_frame(fruit = null, real_collection = false):
	match map.current_fruits.filter(func(f): return f.is_in_group("Ghost Fruit")).size():
		0:
			halo.frame = 0
		1:
			halo.frame = 1
		2:
			halo.frame = 2
		3:
			halo.frame = 3
		4:
			halo.frame = 4
		5:
			halo.frame = 5
		_:
			halo.frame = 6
	await get_tree().create_timer(0.3).timeout
	match map.current_fruits.filter(func(f): return f.is_in_group("Ghost Fruit")).size():
		0:
			halo.frame = 0
		1:
			halo.frame = 1
		2:
			halo.frame = 2
		3:
			halo.frame = 3
		4:
			halo.frame = 4
		5:
			halo.frame = 5
		_:
			halo.frame = 6

func _reset_counter_and_timer():
	ghost_fruit_counter_current = ghost_fruit_counter_max
	immutable_timer.start()

func _spawn_ghost_fruit_upto_5():
	if ghost_fruit_counter_current > 0:
		map.spawn_ghost_fruit([])
		ghost_fruit_counter_current -= 1
	else:
		immutable_timer.stop()
	
func _prevent_growth_on_5_ghostfruits(_fruit, _real_collection):
	#if there are 5 ghost fruits on the map
	if map.current_fruits.filter(func(f): return f.is_in_group("Ghost Fruit")).size() == ghost_fruit_counter_max and map.snake_tail.tiles_to_grow > 0:
		map.snake_tail.tiles_to_grow -= 1
		var growth_effect_trigger_text: EffectTriggerText = EFFECT_TRIGGER_TEXT.instantiate()
		growth_effect_trigger_text.initialize(growth_effect_trigger_text.EFFECTS.NO_GROWTH)
		map.add_child(growth_effect_trigger_text)
	
func self_destruct():
	shop.deal_area_size.position.y -= 5000
	halo.queue_free()
	queue_free()
