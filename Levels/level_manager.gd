class_name LevelManager extends Node2D

var snake_head: SnakeHead
var snake_tail: SnakeTail

var speed_boost_available: bool = true
var fruits_left: int
var time_left: int
var current_map: Map

signal round_over

@onready var speed_boost_bar: SpeedBoostBar = $SpeedBoostBar
@onready var second_ticker: Timer = $SecondTicker
@onready var fruits_left_to_win_label: Label = $FruitsLeftToWin
@onready var speed_boost_frame: AnimatedSprite2D = $SpeedBoostBar/SpeedBoostFrame
@onready var overload_label: Label = $"Overload"
@onready var fruits_left_number_label: Label = $FruitsLeftNumber
@onready var time_left_number_label: Label = $TimeLeftNumber

func _ready() -> void:
	speed_boost_bar.boost_empty_or_full.connect(_on_speed_boost_bar_value_changed)

func prepare_new_act(map: Map ,fruit_threshold: int, time_sec: int):
	if current_map != null:
		current_map.queue_free()
		await get_tree().process_frame
	add_child(map)
	current_map = map
	snake_head = $Map/SnakeHead
	snake_tail = $Map/SnakeTail
	
	current_map.fruit_collected.connect(_on_fruit_collected)
	snake_head.got_hit.connect(on_snake_got_hit)
	prepare_new_round(fruit_threshold, time_sec)

func prepare_new_round(fruit_threshold, time_sec):
	fruits_left = fruit_threshold
	fruits_left_number_label.text = str(fruits_left)
	overload_label.hide()
	fruits_left_to_win_label.show()
	fruits_left_number_label.add_theme_color_override("font_color", Color(1, 1, 1))
	time_left = time_sec
	second_ticker.start()

func on_snake_got_hit():
	fruits_left += 1
	fruits_left_number_label.text = str(fruits_left)
	print("OUCH!!")

func _process(delta: float) -> void:
	decide_speed_boost(delta)

func _on_fruit_collected():
	fruits_left -= 1
	fruits_left_number_label.text = str(abs(fruits_left))
	if fruits_left == 0:
		overload_label.show()
		fruits_left_to_win_label.hide()
		fruits_left_number_label.add_theme_color_override("font_color", Color(0.961, 1.0, 0.41))

func decide_speed_boost(delta):
	if Input.is_action_just_released("speed_boost"):
		snake_head.snake_speed = GameConsts.NORMAL_SPEED
		snake_tail.snake_speed = GameConsts.NORMAL_SPEED
		speed_boost_available = false
		speed_boost_frame.frame = 1
	if Input.is_action_pressed("speed_boost"):
		if speed_boost_available:
			snake_head.snake_speed = GameConsts.SPEED_BOOST_SPEED
			snake_tail.snake_speed = GameConsts.SPEED_BOOST_SPEED
			speed_boost_bar.value -= 100*delta
	if not speed_boost_available:
		speed_boost_bar.value += 70*delta
			

#either called when empty or when full
func _on_speed_boost_bar_value_changed(full: bool) -> void:
	if full:
		speed_boost_available = true
		speed_boost_frame.frame = 0
	else:
		snake_head.snake_speed = GameConsts.NORMAL_SPEED
		snake_tail.snake_speed = GameConsts.NORMAL_SPEED
		speed_boost_available = false
		speed_boost_frame.frame = 1

func set_fruit_threshold(act: int, round: int):
	fruits_left_number_label.text = str(GameConsts.FRUIT_THRESHOLDS[act*4 + round])


func _on_second_ticker_timeout() -> void:
	time_left -= 1
	time_left_number_label.text = str(time_left)
	if time_left == 0:
		round_over.emit()
