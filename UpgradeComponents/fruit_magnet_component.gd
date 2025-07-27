extends FruitMagnetComponentBase


func _ready() -> void:
	for child in get_children():
		if child is Area2D:
			component_shapes.append(child.get_child(0))
			child.connect("area_entered", _on_area_entered)
			child.connect("area_exited", _on_area_exited)
	SignalBus.next_tile_reached.connect(_on_next_tile_reached)

func self_destruct():
	queue_free()
