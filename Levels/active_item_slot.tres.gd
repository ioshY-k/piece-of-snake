class_name ActiveItemSlot extends Sprite2D

@export var slot_number: int
@onready var h_box_container: HBoxContainer = $HBoxContainer

var item_use_light_scene = load("res://UI/LevelUI/item_use_light.tscn")
var item_lights: Array[Control] = []

func add_light():
	var item_light: Control = item_use_light_scene.instantiate()
	h_box_container.add_child(item_light)
	item_lights.append(item_light)
	item_light.get_child(0).frame = 1

func _on_item_activated(_compopnent, pos):
	print(pos)
	item_lights[pos].get_child(0).frame = 0

func refresh_lights():
	get_child(-1).refresh_uses()
	for item_light in item_lights:
		item_light.get_child(0).frame = 1
