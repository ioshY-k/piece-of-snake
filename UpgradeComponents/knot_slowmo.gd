extends Node

var level:LevelManager
var slow_steps: int = 0
@onready var timer_stop_audio: AudioStreamPlayer = $TimerStopAudio

func _ready() -> void:
	level = get_parent()
	SignalBus.overlapped.connect(_slow_down_time)
	SignalBus.next_tile_reached.connect(_decide_back_to_normal_speed)
	
func _slow_down_time():
	if slow_steps == 0:
		timer_stop_audio.play()
		level.time_meter.grow_and_vanish_effect()
	level.time_meter.change_timer_speed(0.0)
	slow_steps = 3
	print("slowmo")

func _decide_back_to_normal_speed():
	if slow_steps > 0:
		slow_steps -= 1
		print(slow_steps)
	else:
		level.time_meter.change_timer_speed(1)

func self_destruct():
	level.time_meter.change_timer_speed(1)
	queue_free()
