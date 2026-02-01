extends Node

var map:Map
const EFFECT_TRIGGER_TEXT = preload("res://UI/effect_trigger_text.tscn")

func _ready() -> void:
	map = get_parent()
	SignalBus.fruit_collected.connect(_additional_grow)
	SignalBus.next_tile_reached.connect(_make_transparent)

func _additional_grow(fruit, real_collection):
	map.snake_tail.tiles_to_grow += 1
	var effect_trigger_text: EffectTriggerText = EFFECT_TRIGGER_TEXT.instantiate()
	effect_trigger_text.initialize(effect_trigger_text.EFFECTS.DENSE, null)
	get_parent().get_parent().current_map.add_child(effect_trigger_text)

func _make_transparent():
	if not map.snake_path_bodyparts[-1].is_overlap_bodypart:
		map.snake_path_bodyparts[-1].set_overlap(true, true)
	if map.snake_path_bodyparts[map.snake_path_bodyparts.size()/2].is_reverted_on_half:
		map.snake_path_bodyparts[map.snake_path_bodyparts.size()/2].set_overlap(false, false)


func self_destruct():
	queue_free()
