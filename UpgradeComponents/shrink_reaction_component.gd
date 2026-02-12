extends ActionReactionBase

func _ready() -> void:
	upgrade_id = GameConsts.UPGRADE_LIST.SHRINK_REACTION
	super._ready()
	SignalBus.action_triggered.connect(_shrink)

func _shrink(action_index):
	if action_index+1 == slot_index:
		var parts_to_delete: int = 2
		if level.current_map.snake_path_bodyparts.size() < 2:
			return
		elif level.current_map.snake_path_bodyparts.size() == 2:
			parts_to_delete = 1
		for i in range(parts_to_delete):
			var body = level.current_map.snake_path_bodyparts.pop_front()
			body.queue_free()
			var direction = level.current_map.snake_path_directions.pop_front()
