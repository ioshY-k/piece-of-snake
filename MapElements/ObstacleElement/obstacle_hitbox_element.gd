class_name ObstacleHitboxElement extends Area2D

enum DIRECTION {UP,RIGHT,DOWN,LEFT,STOP,DISAPPEAR,APPEAR}

var tween: Tween

@export var path: Array[int]

func _on_tween_finished(_loop):
	tween.pause()
	await SignalBus.next_tile_reached
	tween.play()


func _ready() -> void:
	await SignalBus.next_tile_reached
	tween = self.create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).set_loops()
	for index in len(path):
		var next_pos = position
		var index_stepper = index
		while index_stepper >= 0:
			next_pos = TileHelper.tile_to_position(TileHelper.get_next_tile(TileHelper.position_to_tile(next_pos), path[index_stepper]))
			index_stepper -=1
		tween.tween_property(self, "position", next_pos, GameConsts.NORMAL_SPEED)
		if path[index] == 5:
			tween.set_parallel(true)
			tween.tween_callback(_set_collision.bind(false))
			tween.set_parallel(false)
		if path[index] == 6:
			tween.set_parallel(true)
			tween.tween_callback(_set_collision.bind(true))
			tween.set_parallel(false)
		
	tween.step_finished.connect(_on_tween_finished.bind())
	
func _set_collision(state: bool):
	await tween.step_finished
	set_collision_layer_value(6,state)
