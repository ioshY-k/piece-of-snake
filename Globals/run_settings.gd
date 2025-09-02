extends Node

var current_char = GameConsts.CHAR_LIST.GODOT

var current_difficulty = 0

var shop_phase
var play_phase

func _ready() -> void:
	SignalBus.round_over.connect(func():
		shop_phase = true
		play_phase = false)
	SignalBus.round_started.connect(func():
		shop_phase = false
		play_phase = true)
