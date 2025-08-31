class_name DietBaseComponent extends Sprite2D

var snake_tail: SnakeTail

var decrease_step_size: float
var no_grow_chance: float = 0.0

func _ready() -> void:
	modulate.a = no_grow_chance
	snake_tail = get_parent()
	SignalBus.fruit_collected.connect(_prevent_growth)
	SignalBus.next_tile_reached.connect(_lower_chance)

func _lower_chance():
	if no_grow_chance > 0.0:
		no_grow_chance = max(0.0, no_grow_chance - decrease_step_size)
	change_tail_appearance(no_grow_chance)

func _prevent_growth(_element, _real_collection):
	var check = randf_range(0,1)
	if check < no_grow_chance and snake_tail.tiles_to_grow > 0:
		snake_tail.tiles_to_grow -= 1
	no_grow_chance = 1.0
	change_tail_appearance(no_grow_chance)

func change_tail_appearance(alpha: float):
	modulate.a = alpha

func self_destruct():
	queue_free()
