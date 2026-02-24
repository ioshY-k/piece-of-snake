class_name LevelManager extends Node2D

#child objects
var snake_head: SnakeHead
var snake_tail: SnakeTail
var current_map: Map
var current_map_index: int

#UI Elements + data
@onready var speed_boost_bar: SpeedBoostBar = $SpeedBoostBar
@onready var fruits_left_symbol: Sprite2D = $FruitsLeftSymbol
@onready var speed_boost_frame: AnimatedSprite2D = $SpeedBoostBar/SpeedBoostFrame
@onready var fruits_left_number_label: Label = $FruitsLeftNumber
@onready var active_item_slot_1: Sprite2D = $ActiveItemSlot1
@onready var active_item_slot_2: Sprite2D = $ActiveItemSlot2
@onready var active_item_slot_3: ActiveItemSlot = $ActiveItemSlot3
@onready var upgrade_helper: UpgradeHelper = $UpgradeHelper

var active_item_slots: Array[ActiveItemSlot]
var current_active_items: Array[int] = [-1,-1,-1]
@onready var time_meter: TimeMeter = $TimeMeter
var speed_boost_drain_speed: int = 230
var speed_boost_reload_speed: int = 75
var speed_boost_available: bool = true
var fruits_left: int
var fruits_overload: int
var fruit_punishment: int = 1
var enough_fruits: bool = false
var allergy_mode: bool = false
var ghost_invasion: bool = false
var round_count_down: RoundCountDown

@onready var hit_audio: AudioStreamPlayer = $HitAudio
@onready var eat_fruit_audio: AudioStreamPlayer = $EatFruitAudio

func _ready() -> void:
	active_item_slots = [active_item_slot_1, active_item_slot_2]
	if RunSettings.current_char == GameConsts.CHAR_LIST.CHAMELEON:
		active_item_slots.append(active_item_slot_3)
	active_item_slot_3.hide()
	speed_boost_bar.boost_empty_or_full.connect(_on_speed_boost_bar_value_changed)
	SignalBus.next_tile_reached.connect(_fix_stuck_speed_boost_bar)
	SignalBus.fruit_collected.connect(_on_fruit_collected)
	SignalBus.update_active_slot_infos.connect(_update_active_slot_infos)

#called by run_manager at the start of a run and on new act
func prepare_new_act(map_index: int ,fruit_threshold: int, time_sec: int, mapmod_index: int):
	if current_map != null:
		current_map.queue_free()
		await get_tree().process_frame
	var map: Map = MapData.get_map_scene(map_index).instantiate()
	current_map_index = map_index
	add_child(map)
	
	current_map = map
	current_map.position = MapData.get_map_data0(map_index)[0]
	current_map.scale = MapData.get_map_data0(map_index)[1]
	disable_map()
	snake_head = $Map/SnakeHead
	snake_tail = $Map/SnakeTail
	
	if RunSettings.current_char == GameConsts.CHAR_LIST.TWOHEAD:
		var headswap = current_map.head_swap_component_scene.instantiate()
		headswap.instantiate_as_twohead_ability()
		headswap.remove_from_group("MapMod")
		current_map.add_child(headswap)
	if RunSettings.current_char == GameConsts.CHAR_LIST.RETRO:
		var edge_wrap = current_map.edge_wrap_component_scene.instantiate()
		edge_wrap.instantiate_as_retro_ability()
		current_map.add_child(edge_wrap)
	if RunSettings.current_char == GameConsts.CHAR_LIST.OSTRICH:
		snake_head.base_snake_speed /= 1.4
		snake_tail.base_snake_speed /= 1.4
	
	for upgrade_id in range(len(get_parent().current_upgrades)):
		if get_parent().current_upgrades[upgrade_id]:
			if is_upgrade_reload_necessary(upgrade_id):
				destroy_upgrade(upgrade_id)
				instantiate_upgrade(upgrade_id)
	
	
	map.snake_got_hit.connect(on_snake_got_hit)
	GameConsts.node_being_dragged = null
	
	prepare_new_round(fruit_threshold, time_sec, mapmod_index)
	

func prepare_new_round(fruit_threshold, time_sec, mapmod):
	
	snake_head.current_snake_speed = GameConsts.NORMAL_SPEED
	snake_tail.current_snake_speed = GameConsts.NORMAL_SPEED
	if RunSettings.current_char == GameConsts.CHAR_LIST.OSTRICH:
		snake_head.current_snake_speed /= 1.4
		snake_tail.current_snake_speed /= 1.4
	speed_boost_bar.value  = speed_boost_bar.max_value
	
	for active_item_slot in active_item_slots:
		if active_item_slot.get_child_count() != 1:
			active_item_slot.refresh_lights()
	
	enough_fruits = false
	fruits_left = fruit_threshold
	fruits_overload = 0
	fruits_left_number_label.text = str(fruits_left)
	fruits_left_number_label.add_theme_color_override("font_color", Color(1, 1, 1))
	fruits_left_symbol.modulate = Color(1, 1, 1)
	time_meter.reset()
	if GameConsts.test_mode and get_parent().current_round == 0:
	################################################################################################################
		time_meter.initiate_time_bar(30)
	else:
		time_meter.initiate_time_bar(60)
	################################################################################################################
	current_map.apply_mapmod(mapmod)
	var round_count_down_scene = load("res://RoundCountDown/round_count_down.tscn")
	round_count_down = round_count_down_scene.instantiate()
	add_child(round_count_down)
	if RunSettings.mapmods_enabled:
		var key_string = TextConsts.get_id_string(GameConsts.MAP_MODS, mapmod)
		round_count_down.change_text( TextConsts.get_text(TextConsts.TABLES.MAPMODS, key_string, "DESC" ))
	else:
		round_count_down.change_text( TextConsts.get_text(TextConsts.TABLES.MAPMODS, "NO_MAPMOD", "DESC" ))
	await round_count_down.count_down_finished
	
	SignalBus.round_started.emit()
	enable_map()
	

func on_snake_got_hit():
	#disable the speedboost so that fruit cant be lost in high frequency
	if speed_boost_bar.value < speed_boost_bar.max_value:
		snake_head.current_snake_speed = snake_head.base_snake_speed
		snake_tail.current_snake_speed = snake_tail.base_snake_speed
		speed_boost_available = false
		speed_boost_frame.frame = 1
	
	#don't lose fruit on wall collision while invincible
	if current_map.invincible_ticks > 0:
		return
		
	if fruit_punishment > 0:
		hit_audio.play()
		if RunSettings.current_char == GameConsts.CHAR_LIST.RETRO:
			get_parent().game_over()
	
	decrement_points(fruit_punishment)
	SignalBus.got_hit_and_punished.emit()

func decrement_points(fruit_punishment: int):
	for punish in range(fruit_punishment):
		if not enough_fruits:
			fruits_left += 1
			fruits_left_number_label.text = str(fruits_left)
			SignalBus.fruits_left_changed.emit(fruits_left)
		else:
			if fruits_overload == 0:
				enough_fruits = false
				SignalBus.enough_fruits_changed.emit(false)
				fruits_left_symbol.modulate = Color(1,1,1)
				fruits_left_number_label.add_theme_color_override("font_color", Color(1,1,1))
				fruits_left += 1
				fruits_left_number_label.text = str(fruits_left)
				SignalBus.fruits_left_changed.emit(fruits_left)
			else:
				fruits_overload -= 1
				fruits_left_number_label.text = str(fruits_overload)
				SignalBus.fruits_left_changed.emit(fruits_left)
			

func _process(delta: float) -> void:
	decide_speed_boost(delta)

func _on_fruit_collected(collected_fruit, _is_real_collection):
	eat_fruit_audio.play()
	if allergy_mode:
		return
	if ghost_invasion and collected_fruit != null:
		if not collected_fruit.is_in_group("Ghost Fruit"):
			return
	increment_points()

func increment_points():
	if not enough_fruits:
		fruits_left -= 1
		fruits_left_number_label.text = str(fruits_left)
		SignalBus.fruits_left_changed.emit(fruits_left)
		if fruits_left == 0:
			enough_fruits = true
			SignalBus.enough_fruits_changed.emit(true)
			fruits_left_symbol.modulate = Color(0.961, 1.0, 0.41)
			fruits_left_number_label.add_theme_color_override("font_color", Color(0.961, 1.0, 0.41))
	else:
		fruits_overload += 1
		fruits_left_number_label.text = str(fruits_overload)
		SignalBus.fruits_left_changed.emit(fruits_left)
	
var infinite_speed_boost: bool = false
func decide_speed_boost(delta):
	if Input.is_action_just_released("speed_boost"):
		snake_head.current_snake_speed = snake_head.base_snake_speed
		snake_tail.current_snake_speed = snake_tail.base_snake_speed
		speed_boost_available = false
		speed_boost_frame.frame = 1
	if Input.is_action_pressed("speed_boost"):
		if (speed_boost_available and speed_boost_bar.value>0) or infinite_speed_boost:
			snake_head.current_snake_speed = GameConsts.SPEED_BOOST_SPEED
			snake_tail.current_snake_speed = GameConsts.SPEED_BOOST_SPEED
			speed_boost_bar.value -= speed_boost_drain_speed*delta
	if not speed_boost_available:
		speed_boost_bar.value += speed_boost_reload_speed*delta
			

#either called when empty or when full
func _on_speed_boost_bar_value_changed(full: bool) -> void:
	if full:
		speed_boost_available = true
		speed_boost_frame.frame = 0
	else:
		if not infinite_speed_boost:
			snake_head.current_snake_speed = GameConsts.NORMAL_SPEED
			snake_tail.current_snake_speed = GameConsts.NORMAL_SPEED
		speed_boost_available = false
		speed_boost_frame.frame = 1

#current fix for bug where speed boost never becomes available again
func _fix_stuck_speed_boost_bar():
	if speed_boost_available == false and speed_boost_bar.value == speed_boost_bar.max_value:
		speed_boost_available = true

func set_fruit_threshold(current_act: int, current_round: int):
	fruits_left_number_label.text = str(GameConsts.FRUIT_THRESHOLDS[current_act*4 + current_round])

func _on_timer_expired() -> void:
	SignalBus.round_over.emit()

func instantiate_upgrade(upgrade_id: int):
	var current_active_item_slot
	for i in range(3):
		if upgrade_id == current_active_items[i]:
			current_active_item_slot = active_item_slots[i]
			break
	
	upgrade_helper.add_upgrade(upgrade_id, current_active_item_slot)

func _update_active_slot_infos(upgrade_id: int, slot_name: String):
	if slot_name.contains("1"):
		current_active_items[0] = upgrade_id
	elif slot_name.contains("2"):
		current_active_items[1] = upgrade_id
	elif slot_name.contains("Rainbow"):
		current_active_items[2] = upgrade_id
		active_item_slot_3.show()

func destroy_upgrade(upgrade_id: int):
	upgrade_helper.find_and_destroy_upgrade(upgrade_id)
	
#decides if the upgrade was attached to an object that reloads on a new act eg map and snake
func is_upgrade_reload_necessary(upgrade_id) -> bool:
	return upgrade_helper.determine_upgrade_reload_necessary(upgrade_id)

func disable_map():
	current_map.process_mode = Node.PROCESS_MODE_DISABLED

func enable_map():
	current_map.process_mode = Node.PROCESS_MODE_INHERIT

func _on_test_button_toggled(toggled_on: bool) -> void:
	GameConsts.test_mode = toggled_on
