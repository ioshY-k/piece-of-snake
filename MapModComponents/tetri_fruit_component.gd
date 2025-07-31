extends Node

func _ready() -> void:
	SignalBus.fruit_collected.connect(_on_fruit_collected)

func _on_fruit_collected(_element, _is_real_collection: bool):
	if _is_real_collection:
		print("real collection")
