extends ActionReactionBase

const BUMBLEBEE = preload("res://UpgradeComponents/Bumblebee/bumblebee_1_component.tscn")
const MAY_FLY = preload("res://UpgradeComponents/MayFly/may_fly_1_component.tscn")
const DRAGON_FLY = preload("res://UpgradeComponents/Dragonfly/dragonfly_2_component.tscn")
var insect_spawners: Array

func _ready() -> void:
	upgrade_id = GameConsts.UPGRADE_LIST.INSECT_REACTION
	super._ready()
	SignalBus.action_triggered.connect(_spawn_insect)
	SignalBus.round_over.connect(_cleanup_spawners)

func _spawn_insect(action_index):
	if action_index+1 == slot_index:
		var i = randi()%3
		var insect_spawner
		match i:
			0:
				insect_spawner = BUMBLEBEE.instantiate()
			1:
				insect_spawner = MAY_FLY.instantiate()
			2:
				insect_spawner = DRAGON_FLY.instantiate()
		insect_spawner.one_time_insect = true
		level.add_child(insect_spawner)
		insect_spawners.append(insect_spawner)

func _cleanup_spawners():
	for i in range(insect_spawners.size()):
		var spawner = insect_spawners.pop_front()
		spawner.queue_free()

func self_destruct():
	_cleanup_spawners()
	queue_free()
