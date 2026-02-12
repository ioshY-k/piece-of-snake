extends ActionReactionBase

func _ready() -> void:
	upgrade_id = GameConsts.UPGRADE_LIST.HIT_ACTION
	super._ready()
	SignalBus.got_hit_and_punished.connect(emit_action_trigger_signal)
