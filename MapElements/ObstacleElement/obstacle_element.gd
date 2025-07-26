extends Node2D

enum DIRECTION {UP,RIGHT,DOWN,LEFT,STOP}

var tween: Tween

@export var path: Array[int]

func _on_tween_finished(_loop):
	print("tween")

func _ready() -> void:
	await SignalBus.next_tile_reached
	
	tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).set_loops()
	for index in len(path):
		var next_pos = position
		while index >= 0:
			next_pos = TileHelper.tile_to_position(TileHelper.get_next_tile(TileHelper.position_to_tile(next_pos), path[index]))
			index -=1
		print(next_pos)
		tween.tween_property(self, "position", next_pos, GameConsts.NORMAL_SPEED)
		
	tween.loop_finished.connect(_on_tween_finished.bind())

	
