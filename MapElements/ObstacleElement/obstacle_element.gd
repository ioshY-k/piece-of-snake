class_name ObstacleElement extends AnimatedSprite2D

enum DIRECTION {UP,RIGHT,DOWN,LEFT,STOP,DISAPPEAR,APPEAR}

var tween: Tween

@export var loops: bool
@export var signal_id: int
@export var path: Array[int]

signal walk_path
signal path_walked

func _on_tween_step_finished(_loop):
	tween.pause()
	await SignalBus.next_tile_reached
	if tween != null:
		tween.play()

func _ready() -> void:
	#if it is a looping animation, start the endless loop, else only walk the path on signal emission
	walk_path.connect(_walk_path)
	if loops:
		_walk_path()

func _walk_path():
	await SignalBus.next_tile_reached
	tween = self.create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if RunSettings.current_char == GameConsts.CHAR_LIST.GODOT and get_parent().get_parent().caffeinated:
		tween.set_speed_scale(1.2*1.4)
	elif get_parent().get_parent().caffeinated:
			tween.set_speed_scale(1.2)
	elif RunSettings.current_char == GameConsts.CHAR_LIST.GODOT:
			tween.set_speed_scale(1.4)
	if loops:
		tween.set_loops()
	for index in len(path):
		var next_pos = position
		var index_stepper = index
		while index_stepper >= 0:
			next_pos = TileHelper.tile_to_position(TileHelper.get_next_tile(TileHelper.position_to_tile(next_pos), path[index_stepper]))
			index_stepper -=1
		tween.tween_property(self, "position", next_pos, GameConsts.NORMAL_SPEED)
		if path[index] == 5:
			tween.set_parallel(true)
			tween.tween_property(self, "scale", Vector2(0.0,0.0), GameConsts.NORMAL_SPEED)
			tween.tween_callback(_set_particles.bind(false))
			tween.set_parallel(false)
		if path[index] == 6:
			tween.set_parallel(true)
			tween.tween_property(self, "scale", Vector2(1.0,1.0), GameConsts.NORMAL_SPEED)
			tween.tween_callback(_set_particles.bind(true))
			tween.set_parallel(false)

		
	tween.step_finished.connect(_on_tween_step_finished.bind())
	tween.finished.connect(_kill)

func _kill():
	tween.kill()
	tween = null
	path_walked.emit()

func _set_particles(state: bool):
	for child in get_children():
		if child is CPUParticles2D:
			child.emitting = state
