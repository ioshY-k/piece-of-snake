extends ActionReactionBase

func _ready() -> void:
	upgrade_id = GameConsts.UPGRADE_LIST.INSECT_ACTION
	super._ready()
	SignalBus.insect_caught.connect(emit_action_trigger_signal)
