extends ActionReactionBase

func _ready() -> void:
	upgrade_id = GameConsts.UPGRADE_LIST.GHOST_FRUIT_REACTION
	super._ready()
	SignalBus.action_triggered.connect(_spawn_ghost_fruit)

func _spawn_ghost_fruit(action_index):
	print("triggered", action_index, slot_index)
	if action_index+1 == slot_index:
		level.current_map.spawn_ghost_fruit([])
