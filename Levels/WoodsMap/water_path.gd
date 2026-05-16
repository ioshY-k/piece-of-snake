extends Path2D

@onready var timer: Timer = $Timer
const WATER_DROP_PATH_FOLLOW = preload("res://Levels/WoodsMap/water_drop_path_follow.tscn")

func _ready() -> void:
	timer.timeout.connect(spawn_waterdrop)

func spawn_waterdrop():
	var drop: PathFollow2D = WATER_DROP_PATH_FOLLOW.instantiate()
	add_child(drop)
	var tween = get_tree().create_tween()
	tween.tween_property(drop, "progress_ratio", 1, randf_range(2.3,2.9))
	timer.wait_time = randf_range(0.4,1.4)
	await tween.finished
	drop.queue_free()
