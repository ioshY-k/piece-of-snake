extends Area2D

func _process(delta: float) -> void:
	for area: Darkness in get_overlapping_areas():
			area._get_banished()
