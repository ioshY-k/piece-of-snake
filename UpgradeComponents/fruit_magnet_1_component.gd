extends Area2D

@onready var component_shape: CollisionShape2D = $ComponentShape

var fruits_this_tick: Array[MapElement] = []

func _ready() -> void:
	component_shape.shape.set_size(Vector2(GameConsts.TILE_SIZE/2, GameConsts.TILE_SIZE/2))
	position += Vector2(0,-GameConsts.TILE_SIZE*2)
	get_parent().next_tile_reached.connect(_on_next_tile_reached)


func _on_next_tile_reached():
	for fruit in fruits_this_tick:
		fruit.collision_with.emit()
	fruits_this_tick = []


func _on_area_entered(area: Area2D) -> void:
	print(area)
	fruits_this_tick.append(area)


func _on_area_exited(area: Area2D) -> void:
	fruits_this_tick.erase(area)
