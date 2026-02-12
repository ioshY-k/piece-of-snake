extends ActionReactionBase

var necessary_uses: int = 3
var uses: int = 0

func _ready() -> void:
	upgrade_id = GameConsts.UPGRADE_LIST.ACTIVE_ITEM_ACTION
	super._ready()
	SignalBus.active_item_used.connect(_active_item_uses_up)
	SignalBus.round_over.connect(_reset_uses)

func _active_item_uses_up():
	uses += 1
	if uses%3 == 0:
		emit_action_trigger_signal()

func _reset_uses():
	uses = 0
