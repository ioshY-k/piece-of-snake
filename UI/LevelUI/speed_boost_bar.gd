class_name SpeedBoostBar extends ProgressBar

signal boost_empty_or_full

func _on_value_changed(value: float) -> void:
	if value == min_value:
		boost_empty_or_full.emit(false)
	if value == max_value:
		boost_empty_or_full.emit(true)
