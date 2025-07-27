class_name FruitMagnetComponentBase extends Node2D


@onready var component_shapes: Array[CollisionShape2D]

var fruits_this_tick: Array[FruitElement] = []

func _on_next_tile_reached():
	for fruit in fruits_this_tick:
		if not fruit.collected:
			fruit.collision_with.emit()
	fruits_this_tick = []


func _on_area_entered(area: Area2D) -> void:
	fruits_this_tick.append(area)


func _on_area_exited(area: Area2D) -> void:
	fruits_this_tick.erase(area)
