extends Node

func _ready() -> void:
	SignalBus.round_started.connect(_upgrade_bodymods)

func _upgrade_bodymods():
	SignalBus.swiss_knive_synergy.emit(true)

func self_destruct():
	SignalBus.swiss_knive_synergy.emit(false)
	queue_free()
