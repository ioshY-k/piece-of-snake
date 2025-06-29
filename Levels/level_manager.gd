class_name LevelManager extends Node2D

var snake_head: SnakeHead
var snake_tail: SnakeTail

var speed_boost_drain_speed: int = 230
var speed_boost_available: bool = true
var fruits_left: int
var fruits_overload: int
var time_left: int
var enough_fruits: bool = false
var current_map: Map

signal round_over

@onready var speed_boost_bar: SpeedBoostBar = $SpeedBoostBar
@onready var fruits_left_symbol: Sprite2D = $FruitsLeftSymbol
@onready var speed_boost_frame: AnimatedSprite2D = $SpeedBoostBar/SpeedBoostFrame
@onready var fruits_left_number_label: Label = $FruitsLeftNumber
@onready var active_item_slot_1: Node2D = $ActiveItemSlot1
@onready var time_meter: TimeMeter = $TimeMeter

var fruit_relocator_1_component_scene = load("res://UpgradeComponents/fruit_relocator_1_component.tscn")
var hyper_speed_1_component_scene = load("res://UpgradeComponents/hyper_speed_1_component.tscn")

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
	
	for upgrade_id in range(len(get_parent().current_upgrades)):
		if get_parent().current_upgrades[upgrade_id]:
			if is_upgrade_reload_necessary(upgrade_id):
				instantiate_upgrade(upgrade_id)
	
	
	current_map.fruit_collected.connect(_on_fruit_collected)
	snake_head.got_hit.connect(on_snake_got_hit)
	GameConsts.node_being_dragged = null
	
	prepare_new_round(fruit_threshold, time_sec)
	

func prepare_new_round(fruit_threshold, time_sec):
	
	snake_head.snake_speed = GameConsts.NORMAL_SPEED
	snake_tail.snake_speed = GameConsts.NORMAL_SPEED
	speed_boost_bar.value  = speed_boost_bar.max_value
	
	enough_fruits = false
	fruits_left = fruit_threshold
	fruits_overload = 0
	fruits_left_number_label.text = str(fruits_left)
	fruits_left_number_label.add_theme_color_override("font_color", Color(1, 1, 1))
	fruits_left_symbol.modulate = Color(1, 1, 1)
	time_meter.reset()
	time_meter.initiate_time_bar(GameConsts.ROUND_TIME_SEC)
	

func on_snake_got_hit():
	print("Ouch!")
	if not enough_fruits:
		fruits_left += 1
		fruits_left_number_label.text = str(fruits_left)
	else:
		if fruits_overload == 0:
			enough_fruits = false
			fruits_left_symbol.modulate = Color(1,1,1)
			fruits_left_number_label.add_theme_color_override("font_color", Color(1,1,1))
			fruits_left += 1
			fruits_left_number_label.text = str(fruits_left)
		else:
			fruits_overload -= 1
			fruits_left_number_label.text = str(fruits_overload)
			

func _process(delta: float) -> void:
	decide_speed_boost(delta)

func _on_fruit_collected():
	print("YUM!")
	if not enough_fruits:
		fruits_left -= 1
		fruits_left_number_label.text = str(fruits_left)
		if fruits_left == 0:
			enough_fruits = true
			fruits_left_symbol.modulate = Color(0.961, 1.0, 0.41)
			fruits_left_number_label.add_theme_color_override("font_color", Color(0.961, 1.0, 0.41))
	else:
		fruits_overload += 1
		fruits_left_number_label.text = str(fruits_overload)

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
			speed_boost_bar.value -= speed_boost_drain_speed*delta
	if not speed_boost_available:
		speed_boost_bar.value += 90*delta
			

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

func set_fruit_threshold(current_act: int, current_round: int):
	fruits_left_number_label.text = str(GameConsts.FRUIT_THRESHOLDS[current_act*4 + current_round])


func _on_timer_expired() -> void:
	round_over.emit()

func instantiate_upgrade(upgrade_id: int):
	match upgrade_id:
		GameConsts.UPGRADE_LIST.FRUIT_MAGNET_1:
			current_map.add_upgrade_component(upgrade_id)
		GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_1:
			var fruit_relocator_1_component = fruit_relocator_1_component_scene.instantiate()
			active_item_slot_1.add_child(fruit_relocator_1_component)
		GameConsts.UPGRADE_LIST.HYPER_SPEED_1:
			var hyper_speed_1_component = hyper_speed_1_component_scene.instantiate()
			speed_boost_bar.add_child(hyper_speed_1_component)
		GameConsts.UPGRADE_LIST.FRUIT_MAGNET_2:
			current_map.add_upgrade_component(upgrade_id)


func destroy_upgrade(upgrade_id: int):
	var component
	match upgrade_id:
		GameConsts.UPGRADE_LIST.FRUIT_MAGNET_1:
			component = current_map.snake_head.find_child("FruitMagnet1Component",false,false)
		GameConsts.UPGRADE_LIST.FRUIT_MAGNET_2:
			component = current_map.snake_head.find_child("FruitMagnet2Component",false,false)
		GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_1:
			component = active_item_slot_1.find_child("FruitRelocator1Component",false,false)			
		GameConsts.UPGRADE_LIST.HYPER_SPEED_1:
			component = speed_boost_bar.find_child("HyperSpeed1Component",false,false)
	
	if component != null:
		component.self_destruct()
	else:
		print_debug("No Component found to be destroyed")
	
	

func is_upgrade_reload_necessary(upgrade_id) -> bool:
	match upgrade_id:
		GameConsts.UPGRADE_LIST.HYPER_SPEED_1,\
		GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_1:
			return false
		GameConsts.UPGRADE_LIST.FRUIT_MAGNET_1,\
		GameConsts.UPGRADE_LIST.FRUIT_MAGNET_2:
			return true
		_:
			return false

func _on_item_activated(upgrade_id: int):
	match upgrade_id:
		GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_1:
			var fruits: Array[MapElement] = current_map.find_all_fruits()
			var fruit_tiles: Array[Vector2i] = []
			for fruit in fruits:
				fruit_tiles.append(GameConsts.position_to_tile(fruit.position))
			
			var surrounding_fruit_tiles: Array[Vector2i] =[]
			for fruit_position in fruit_tiles:
				var x = fruit_position.x - 2
				var y = fruit_position.y -2
				while x <= fruit_position.x + 2:
					while y <= fruit_position.y + 2:
						surrounding_fruit_tiles.append(Vector2i(x,y))
						y += 1
					x += 1
					y = fruit_position.y -2
			
			fruit_tiles.append_array(surrounding_fruit_tiles)
			
			for fruit in fruits:
				current_map.relocate_fruit(fruit, fruit_tiles)
	
func disable_map():
	current_map.process_mode = Node.PROCESS_MODE_DISABLED

func enable_map():
	current_map.process_mode = Node.PROCESS_MODE_INHERIT
	
