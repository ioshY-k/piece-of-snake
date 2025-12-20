extends Sprite2D

var swiss_knive = false
@onready var area_2d_default: Area2D = $Area2DDefault
@onready var area_2d_swiss_knive: Area2D = $Area2DSwissKnive

func _ready() -> void:
	SignalBus.swiss_knive_synergy.connect(_set_swiss_knive)

func _process(delta: float) -> void:
	for area: Darkness in area_2d_default.get_overlapping_areas():
			area._get_banished()

func _set_swiss_knive(state:bool):
	swiss_knive = state
	if swiss_knive:
		area_2d_default.set_collision_layer_value(15,false)
		area_2d_swiss_knive.set_collision_layer_value(15,true)
	else:
		area_2d_default.set_collision_layer_value(15,true)
		area_2d_swiss_knive.set_collision_layer_value(15,false)

func self_destruct():
	queue_free()
