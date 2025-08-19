class_name SpeedBoostBar extends ProgressBar

signal boost_empty_or_full
@onready var speed_boost_frame: AnimatedSprite2D = $SpeedBoostFrame

func _on_value_changed(value: float) -> void:
	if value == min_value:
		boost_empty_or_full.emit(false)
	if value == max_value:
		boost_empty_or_full.emit(true)

func change_animation(anim: String):
	speed_boost_frame.play(anim)
	speed_boost_frame.frame = 0
