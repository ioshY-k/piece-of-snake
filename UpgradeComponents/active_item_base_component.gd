class_name ActiveItemBase extends Node2D

var max_uses: int
var uses: int
signal item_activated
var active_item_slot: ActiveItemSlot
var active_item_button: String
var shop_phase: bool = true

func _ready() -> void:
	SignalBus.round_started.connect(_on_round_start)
	SignalBus.round_over.connect(_on_round_over)

func initiate_active_item(use_num: int, slot: int):
	print("uses set to " + str(use_num))
	max_uses = use_num
	uses = use_num
	for use in range(uses):
		active_item_slot.add_light()
	if slot == 1:
		active_item_button = "item1"
	else:
		active_item_button = "item2"

func refresh_uses():
	uses = max_uses

func _on_round_start():
	shop_phase = false


func _on_round_over():
	shop_phase = true
