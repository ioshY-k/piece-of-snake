class_name BigFruitBaseComponent extends Node

var size_vector
var pos_offset

func _ready() -> void:
	SignalBus.fruit_spawned.connect(_grow)
	SignalBus.ghost_fruit_spawned.connect(_grow)

func _grow(fruit: FruitElement):
	var grow_tween:Tween = create_tween()
	grow_tween.set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT).set_parallel(true)
	grow_tween.tween_property(fruit, "scale", size_vector, 0.5)
	grow_tween.tween_property(fruit, "position", fruit.position + pos_offset, 0.5)
	fruit.big = true
