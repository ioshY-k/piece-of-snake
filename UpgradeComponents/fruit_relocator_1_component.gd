extends Node2D

var uses = 2
signal item_activated
func _ready() -> void:
	get_parent().get_parent().round_over.connect(_on_round_over)
	item_activated.connect(get_parent().get_parent()._on_item_activated)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("item1") and uses > 0:
		item_activated.emit(GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_1)
		uses -= 1

func _on_round_over():
	uses = 2

func self_destruct():
	queue_free()
