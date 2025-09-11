extends Sprite2D

var snake_head: SnakeHead

func _ready() -> void:
	snake_head = get_parent()
	hide()

func _process(delta: float) -> void:
	if snake_head.current_snake_speed == GameConsts.SPEED_BOOST_SPEED:
		show()
	else:
		hide()
