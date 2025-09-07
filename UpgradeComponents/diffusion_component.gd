extends Node

var map:Map
var swiss_knive

func _ready():
	map = get_parent().current_map
	SignalBus.fruit_spawned.connect(_make_diffusable)
	SignalBus.ghost_fruit_spawned.connect(_make_diffusable)
	SignalBus.swiss_knive_synergy.connect(_set_swiss_knive)

func _set_swiss_knive(state:bool):
	swiss_knive = state
	if swiss_knive and not SignalBus.diffusion_happened.is_connected(_move_all_fruits):
		SignalBus.diffusion_happened.connect(_move_all_fruits)
	else:
		if SignalBus.diffusion_happened.is_connected(_move_all_fruits):
			SignalBus.diffusion_happened.disconnect(_move_all_fruits)

func _move_all_fruits():
	for fruit in map.current_fruits:
		fruit.move(fruit.move_type.TOWARDS, false)

func _make_diffusable(fruit: FruitElement):
	fruit.diffusable = true

func self_destruct():
	for fruit:FruitElement in map.find_all_fruits():
		fruit.diffusable = false
	queue_free()
