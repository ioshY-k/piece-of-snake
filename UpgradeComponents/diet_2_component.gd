extends DietBaseComponent

func _ready() -> void:
	super._ready()
	decrease_step_size = 0.2
	SignalBus.enough_fruits_changed.connect(_no_growth_guaranteed)
	SignalBus.round_started.connect(_no_growth_guaranteed.bind(false))

func _no_growth_guaranteed(is_guaranteed:bool):
	if is_guaranteed:
		decrease_step_size = 0.1
	else:
		decrease_step_size = 0.2
		
