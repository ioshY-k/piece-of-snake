extends DietBaseComponent

func _ready() -> void:
	super._ready()
	decrease_step_size = 0.06
	SignalBus.enough_fruits_changed.connect(_no_growth_guaranteed)

func _no_growth_guaranteed(is_guaranteed:bool):
	await get_tree().process_frame
	if is_guaranteed:
		no_grow_chance = 1.0
		decrease_step_size = 0.0
	else:
		no_grow_chance = 0.0
		change_tail_appearance(no_grow_chance)
		decrease_step_size = 0.06
		
