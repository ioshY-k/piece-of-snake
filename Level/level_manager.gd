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

var active_item_slots: Array[ActiveItemSlot]
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

#Upgrade Components
var fruit_relocator_component_scene = load("res://UpgradeComponents/fruit_relocator_component.tscn")
var hyper_speed_1_component_scene = load("res://UpgradeComponents/hyper_speed_1_component.tscn")
var hyper_speed_2_component_scene = load("res://UpgradeComponents/hyper_speed_2_component.tscn")
var hyper_speed_3_component_scene = load("res://UpgradeComponents/hyper_speed_3_component.tscn")
var area_size_1_component_scene = load("res://UpgradeComponents/area_size_1_component.tscn")
var area_size_2_component_scene = load("res://UpgradeComponents/area_size_2_component.tscn")
var area_size_3_component_scene = load("res://UpgradeComponents/area_size_3_component.tscn")
var time_stop_1_component_scene = load("res://UpgradeComponents/time_stop_1_component.tscn")
var time_stop_2_component_scene = load("res://UpgradeComponents/time_stop_2_component.tscn")
var time_stop_3_component_scene = load("res://UpgradeComponents/time_stop_3_component.tscn")
var item_reloader_component_scene = load("res://UpgradeComponents/item_reloader_component.tscn")
var knot_slowmo_component_scene = load("res://UpgradeComponents/knot_slowmo.tscn")
var coating_component_scene = load("res://UpgradeComponents/coating_component.tscn")
var wormhole_component_scene = load("res://UpgradeComponents/wormhole_component.tscn")
var crossroad_1_component_scene = load("res://UpgradeComponents/crossroad_1_component.tscn")
var moulting_component_scene = load("res://UpgradeComponents/moulting_component.tscn")
var piggy_bank_component_scene = load("res://UpgradeComponents/piggy_bank_component.tscn")
var sale_component_scene = load("res://UpgradeComponents/sale_component.tscn")
var fuel_1_component_scene = load("res://UpgradeComponents/fuel_1_component.tscn")
var fuel_2_component_scene = load("res://UpgradeComponents/fuel_2_component.tscn")
var fuel_3_component_scene = load("res://UpgradeComponents/fuel_3_component.tscn")
var swiss_knive_component_scene = load("res://UpgradeComponents/swiss_knive_component.tscn")
var pacman_component_scene = load("res://UpgradeComponents/pacman_component.tscn")
var shiny_ghost_component_scene = load("res://UpgradeComponents/shiny_ghost_component.tscn")
var allergy_component_scene = load("res://UpgradeComponents/allergy_component.tscn")
var snek_1_component_scene = load("res://UpgradeComponents/snek_1_component.tscn")
var snek_2_component_scene = load("res://UpgradeComponents/snek_2_component.tscn")
var power_nap_component_scene = load("res://UpgradeComponents/power_nap_component.tscn")
var catch_component_scene = load("res://UpgradeComponents/catch_component.tscn")
var diffusion_component_scene = load("res://UpgradeComponents/diffusion_component.tscn")
var big_fruit_1_component_scene = load("res://UpgradeComponents/big_fruit_1_component.tscn")
var big_fruit_2_component_scene = load("res://UpgradeComponents/big_fruit_2_component.tscn")
var big_fruit_3_component_scene = load("res://UpgradeComponents/big_fruit_3_component.tscn")
var overfed_component_scene = load("res://UpgradeComponents/overfed_component.tscn")

@onready var hit_audio: AudioStreamPlayer = $HitAudio
@onready var eat_fruit_audio: AudioStreamPlayer = $EatFruitAudio

func _ready() -> void:
	active_item_slots = [active_item_slot_1, active_item_slot_2]
	speed_boost_bar.boost_empty_or_full.connect(_on_speed_boost_bar_value_changed)
	SignalBus.next_tile_reached.connect(_fix_stuck_speed_boost_bar)
	SignalBus.fruit_collected.connect(_on_fruit_collected)

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
	
	for upgrade_id in range(len(get_parent().current_upgrades)):
		if get_parent().current_upgrades[upgrade_id]:
			if is_upgrade_reload_necessary(upgrade_id):
				instantiate_upgrade(upgrade_id)
	
	
	map.snake_got_hit.connect(on_snake_got_hit)
	GameConsts.node_being_dragged = null
	
	prepare_new_round(fruit_threshold, time_sec, mapmod_index)
	

func prepare_new_round(fruit_threshold, time_sec, mapmod):
	
	snake_head.current_snake_speed = GameConsts.NORMAL_SPEED
	snake_tail.current_snake_speed = GameConsts.NORMAL_SPEED
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
		time_meter.initiate_time_bar(4)
	else:
		time_meter.initiate_time_bar(GameConsts.ROUND_TIME_SEC)
	
	current_map.apply_mapmod(mapmod)
	var round_count_down_scene = load("res://RoundCountDown/round_count_down.tscn")
	round_count_down = round_count_down_scene.instantiate()
	add_child(round_count_down)
	round_count_down.change_text(Descriptions.mapmod_descriptions[str(mapmod)])
	await round_count_down.count_down_finished
	
	SignalBus.round_started.emit()
	enable_map()
	

func on_snake_got_hit():
	#disable the speedboost so that fruit cant be lost in high frequency
	if speed_boost_bar.value < speed_boost_bar.max_value:
		snake_head.current_snake_speed = GameConsts.NORMAL_SPEED
		snake_tail.current_snake_speed = GameConsts.NORMAL_SPEED
		speed_boost_available = false
		speed_boost_frame.frame = 1
	
	#don't lose fruit on wall collision while invincible
	if current_map.invincible_ticks > 0:
		return
		
	if fruit_punishment > 0:
		hit_audio.play()
	
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
	

func decide_speed_boost(delta):
	if Input.is_action_just_released("speed_boost"):
		snake_head.current_snake_speed = snake_head.base_snake_speed
		snake_tail.current_snake_speed = snake_tail.base_snake_speed
		speed_boost_available = false
		speed_boost_frame.frame = 1
	if Input.is_action_pressed("speed_boost"):
		if speed_boost_available and speed_boost_bar.value>0:
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
	var slot: int = 0
	for active_item_slot in active_item_slots:
		slot += 1
		if active_item_slot.get_child_count() == 1:
			current_active_item_slot = active_item_slot
			break
			
	match upgrade_id:
		GameConsts.UPGRADE_LIST.AREA_SIZE_1:
			var area_size_1_component = area_size_1_component_scene.instantiate()
			add_child(area_size_1_component)
		GameConsts.UPGRADE_LIST.AREA_SIZE_2:
			var area_size_2_component = area_size_2_component_scene.instantiate()
			add_child(area_size_2_component)
		GameConsts.UPGRADE_LIST.AREA_SIZE_3:
			var area_size_3_component = area_size_3_component_scene.instantiate()
			add_child(area_size_3_component)
		GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_1:
			var fruit_relocator_component = fruit_relocator_component_scene.instantiate()
			current_active_item_slot.add_child(fruit_relocator_component)
			fruit_relocator_component.initiate_active_item(2, slot)
		GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_2:
			var fruit_relocator_component = fruit_relocator_component_scene.instantiate()
			current_active_item_slot.add_child(fruit_relocator_component)
			fruit_relocator_component.initiate_active_item(4, slot)
		GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_3:
			var fruit_relocator_component = fruit_relocator_component_scene.instantiate()
			current_active_item_slot.add_child(fruit_relocator_component)
			fruit_relocator_component.initiate_active_item(6, slot)
		GameConsts.UPGRADE_LIST.PACMAN_1:
			var pacman_component = pacman_component_scene.instantiate()
			current_active_item_slot.add_child(pacman_component)
			pacman_component.initiate_active_item(3, slot)
		GameConsts.UPGRADE_LIST.PACMAN_2:
			var pacman_component = pacman_component_scene.instantiate()
			current_active_item_slot.add_child(pacman_component)
			pacman_component.initiate_active_item(5, slot)
		GameConsts.UPGRADE_LIST.PACMAN_3:
			var pacman_component = pacman_component_scene.instantiate()
			current_active_item_slot.add_child(pacman_component)
			pacman_component.initiate_active_item(7, slot)
		GameConsts.UPGRADE_LIST.TIME_STOP_1:
			var time_stop_1_component = time_stop_1_component_scene.instantiate()
			current_active_item_slot.add_child(time_stop_1_component)
			time_stop_1_component.initiate_active_item(3, slot)
		GameConsts.UPGRADE_LIST.TIME_STOP_2:
			var time_stop_2_component = time_stop_2_component_scene.instantiate()
			current_active_item_slot.add_child(time_stop_2_component)
			time_stop_2_component.initiate_active_item(3, slot)
		GameConsts.UPGRADE_LIST.TIME_STOP_3:
			var time_stop_3_component = time_stop_3_component_scene.instantiate()
			current_active_item_slot.add_child(time_stop_3_component)
			time_stop_3_component.initiate_active_item(3, slot)
		GameConsts.UPGRADE_LIST.WORMHOLE_1:
			var wormhole_component = wormhole_component_scene.instantiate()
			current_active_item_slot.add_child(wormhole_component)
			wormhole_component.initiate_active_item(2, slot)
		GameConsts.UPGRADE_LIST.WORMHOLE_2:
			var wormhole_component = wormhole_component_scene.instantiate()
			current_active_item_slot.add_child(wormhole_component)
			wormhole_component.initiate_active_item(4, slot)
		GameConsts.UPGRADE_LIST.WORMHOLE_3:
			var wormhole_component = wormhole_component_scene.instantiate()
			current_active_item_slot.add_child(wormhole_component)
			wormhole_component.initiate_active_item(6, slot)
		GameConsts.UPGRADE_LIST.SNEK_1:
			var snek_1_component = snek_1_component_scene.instantiate()
			current_active_item_slot.add_child(snek_1_component)
			snek_1_component.initiate_active_item(2, slot)
		GameConsts.UPGRADE_LIST.SNEK_2:
			var snek_2_component = snek_2_component_scene.instantiate()
			current_active_item_slot.add_child(snek_2_component)
			snek_2_component.initiate_active_item(2, slot)
		GameConsts.UPGRADE_LIST.SNEK_3:
			var snek_2_component = snek_2_component_scene.instantiate()
			current_active_item_slot.add_child(snek_2_component)
			snek_2_component.initiate_active_item(3, slot)
		GameConsts.UPGRADE_LIST.HYPER_SPEED_1:
			var hyper_speed_1_component = hyper_speed_1_component_scene.instantiate()
			speed_boost_bar.add_child(hyper_speed_1_component)
		GameConsts.UPGRADE_LIST.HYPER_SPEED_2:
			var hyper_speed_2_component = hyper_speed_2_component_scene.instantiate()
			speed_boost_bar.add_child(hyper_speed_2_component)
		GameConsts.UPGRADE_LIST.HYPER_SPEED_3:
			var hyper_speed_3_component = hyper_speed_3_component_scene.instantiate()
			speed_boost_bar.add_child(hyper_speed_3_component)
		GameConsts.UPGRADE_LIST.FUEL_1:
			var fuel_1_component = fuel_1_component_scene.instantiate()
			speed_boost_bar.add_child(fuel_1_component)
		GameConsts.UPGRADE_LIST.FUEL_2:
			var fuel_2_component = fuel_2_component_scene.instantiate()
			speed_boost_bar.add_child(fuel_2_component)
		GameConsts.UPGRADE_LIST.FUEL_3:
			var fuel_3_component = fuel_3_component_scene.instantiate()
			speed_boost_bar.add_child(fuel_3_component)
		GameConsts.UPGRADE_LIST.BIG_FRUIT_1:
			var big_fruit_1_component = big_fruit_1_component_scene.instantiate()
			add_child(big_fruit_1_component)
		GameConsts.UPGRADE_LIST.BIG_FRUIT_2:
			var big_fruit_2_component = big_fruit_2_component_scene.instantiate()
			add_child(big_fruit_2_component)
		GameConsts.UPGRADE_LIST.BIG_FRUIT_3:
			var big_fruit_3_component = big_fruit_3_component_scene.instantiate()
			add_child(big_fruit_3_component)
		GameConsts.UPGRADE_LIST.ITEM_RELOADER:
			var item_reloader_component = item_reloader_component_scene.instantiate()
			add_child(item_reloader_component)
		GameConsts.UPGRADE_LIST.KNOT_SLOWMO:
			var knot_slowmo_component = knot_slowmo_component_scene.instantiate()
			add_child(knot_slowmo_component)
		GameConsts.UPGRADE_LIST.COATING:
			var coating_component = coating_component_scene.instantiate()
			add_child(coating_component)
		GameConsts.UPGRADE_LIST.DIFFUSION:
			var diffusion_component = diffusion_component_scene.instantiate()
			add_child(diffusion_component)
		GameConsts.UPGRADE_LIST.SWISS_KNIVE:
			var swiss_knive_component = swiss_knive_component_scene.instantiate()
			add_child(swiss_knive_component)
		GameConsts.UPGRADE_LIST.PIGGY_BANK:
			var piggy_bank_component = piggy_bank_component_scene.instantiate()
			add_child(piggy_bank_component)
		GameConsts.UPGRADE_LIST.SALE:
			var sale_component = sale_component_scene.instantiate()
			get_parent().shop.add_child(sale_component)
		GameConsts.UPGRADE_LIST.OVERFED:
			var overfed_component = overfed_component_scene.instantiate()
			get_parent().shop.add_child(overfed_component)
		GameConsts.UPGRADE_LIST.MOULTING:
			var moulting_component = moulting_component_scene.instantiate()
			add_child(moulting_component)
		GameConsts.UPGRADE_LIST.ALLERGY:
			var allergy_component = allergy_component_scene.instantiate()
			add_child(allergy_component)
		GameConsts.UPGRADE_LIST.SHINY_GHOST:
			var shiny_ghost_component = shiny_ghost_component_scene.instantiate()
			add_child(shiny_ghost_component)
		GameConsts.UPGRADE_LIST.POWER_NAP:
			var power_nap_component = power_nap_component_scene.instantiate()
			add_child(power_nap_component)
		GameConsts.UPGRADE_LIST.CATCH:
			var catch_component = catch_component_scene.instantiate()
			add_child(catch_component)
		GameConsts.UPGRADE_LIST.CROSS_ROAD_1:
			var crossroad_1_component = crossroad_1_component_scene.instantiate()
			current_active_item_slot.add_child(crossroad_1_component)
			crossroad_1_component.initiate_active_item(1, slot)
		GameConsts.UPGRADE_LIST.CROSS_ROAD_2:
			var crossroad_2_component = crossroad_1_component_scene.instantiate()
			crossroad_2_component.big_crossroad = true
			current_active_item_slot.add_child(crossroad_2_component)
			crossroad_2_component.initiate_active_item(1, slot)
		GameConsts.UPGRADE_LIST.CROSS_ROAD_3:
			var crossroad_3_component = crossroad_1_component_scene.instantiate()
			crossroad_3_component.big_crossroad = true
			current_active_item_slot.add_child(crossroad_3_component)
			crossroad_3_component.initiate_active_item(2, slot)
		GameConsts.UPGRADE_LIST.FRUIT_MAGNET_1,\
		GameConsts.UPGRADE_LIST.FRUIT_MAGNET_2,\
		GameConsts.UPGRADE_LIST.FRUIT_MAGNET_3,\
		GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_1,\
		GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_2,\
		GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_3,\
		GameConsts.UPGRADE_LIST.EDGE_WRAP,\
		GameConsts.UPGRADE_LIST.DANCE,\
		GameConsts.UPGRADE_LIST.CORNER_PHASING,\
		GameConsts.UPGRADE_LIST.TAIL_CUT,\
		GameConsts.UPGRADE_LIST.STEEL_HELMET,\
		GameConsts.UPGRADE_LIST.ANCHOR,\
		GameConsts.UPGRADE_LIST.DIET_1,\
		GameConsts.UPGRADE_LIST.DIET_2,\
		GameConsts.UPGRADE_LIST.DIET_3,\
		GameConsts.UPGRADE_LIST.MAGIC_FLUTE_1,\
		GameConsts.UPGRADE_LIST.MAGIC_FLUTE_2,\
		GameConsts.UPGRADE_LIST.MAGIC_FLUTE_3,\
		GameConsts.UPGRADE_LIST.RUBBER_BAND,\
		GameConsts.UPGRADE_LIST.HALF_GONE,\
		GameConsts.UPGRADE_LIST.IMMUTABLE,\
		GameConsts.UPGRADE_LIST.PLANT_SNAKE:
			current_map.add_upgrade_component(upgrade_id)

func destroy_upgrade(upgrade_id: int):
	var component
	match upgrade_id:
		GameConsts.UPGRADE_LIST.AREA_SIZE_1:
			component = find_child("AreaSize1Component",false,false)
		GameConsts.UPGRADE_LIST.AREA_SIZE_2:
			component = find_child("AreaSize2Component",false,false)
		GameConsts.UPGRADE_LIST.AREA_SIZE_3:
			component = find_child("AreaSize3Component",false,false)
		GameConsts.UPGRADE_LIST.FRUIT_MAGNET_1:
			component = current_map.snake_head.find_child("FruitMagnet1Component",false,false)
		GameConsts.UPGRADE_LIST.FRUIT_MAGNET_2:
			component = current_map.snake_head.find_child("FruitMagnet2Component",false,false)
		GameConsts.UPGRADE_LIST.FRUIT_MAGNET_3:
			component = current_map.snake_head.find_child("FruitMagnet3Component",false,false)
		GameConsts.UPGRADE_LIST.DIET_1:
			component = current_map.snake_tail.find_child("Diet1Component",false,false)
		GameConsts.UPGRADE_LIST.DIET_2:
			component = current_map.snake_tail.find_child("Diet2Component",false,false)
		GameConsts.UPGRADE_LIST.DIET_3:
			component = current_map.snake_tail.find_child("Diet3Component",false,false)
		GameConsts.UPGRADE_LIST.IMMUTABLE:
			component = current_map.find_child("ImmutableComponent",false,false)
		GameConsts.UPGRADE_LIST.MAGIC_FLUTE_1:
			component = current_map.find_child("MagicFlute1Component",false,false)
		GameConsts.UPGRADE_LIST.MAGIC_FLUTE_2:
			component = current_map.find_child("MagicFlute2Component",false,false)
		GameConsts.UPGRADE_LIST.MAGIC_FLUTE_3:
			component = current_map.find_child("MagicFlute3Component",false,false)
		GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_1,\
		GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_2,\
		GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_3:
			component = active_item_slot_1.find_child("FruitRelocatorComponent", false, false)
		GameConsts.UPGRADE_LIST.PACMAN_1,\
		GameConsts.UPGRADE_LIST.PACMAN_2,\
		GameConsts.UPGRADE_LIST.PACMAN_3:
			component = active_item_slot_1.find_child("PacmanComponent", false, false)
			if component == null:
				component = active_item_slot_2.find_child("PacmanComponent", false, false)
		GameConsts.UPGRADE_LIST.SNEK_1:
			component = active_item_slot_1.find_child("Snek1Component", false, false)
			if component == null:
				component = active_item_slot_2.find_child("Snek1Component", false, false)
		GameConsts.UPGRADE_LIST.SNEK_2,\
		GameConsts.UPGRADE_LIST.SNEK_3:
			component = active_item_slot_1.find_child("Snek2Component", false, false)
			if component == null:
				component = active_item_slot_2.find_child("Snek2Component", false, false)
		GameConsts.UPGRADE_LIST.CROSS_ROAD_1,\
		GameConsts.UPGRADE_LIST.CROSS_ROAD_2,\
		GameConsts.UPGRADE_LIST.CROSS_ROAD_3:
			component = active_item_slot_1.find_child("Crossroad1Component", false, false)
			if component == null:
				component = active_item_slot_2.find_child("Crossroad1Component", false, false)
		GameConsts.UPGRADE_LIST.TIME_STOP_1:
			component = active_item_slot_1.find_child("TimeStop1Component",false,false)
			if component == null:
				component = active_item_slot_2.find_child("TimeStop1Component", false, false)
		GameConsts.UPGRADE_LIST.TIME_STOP_2:
			component = active_item_slot_1.find_child("TimeStop2Component",false,false)
			if component == null:
				component = active_item_slot_2.find_child("TimeStop2Component", false, false)
		GameConsts.UPGRADE_LIST.TIME_STOP_3:
			component = active_item_slot_1.find_child("TimeStop3Component",false,false)
			if component == null:
				component = active_item_slot_2.find_child("TimeStop3Component", false, false)
		GameConsts.UPGRADE_LIST.WORMHOLE_1,\
		GameConsts.UPGRADE_LIST.WORMHOLE_2,\
		GameConsts.UPGRADE_LIST.WORMHOLE_3:
			component = active_item_slot_1.find_child("WormholeComponent",false,false)
			if component == null:
				component = active_item_slot_2.find_child("WormholeComponent", false, false)
		GameConsts.UPGRADE_LIST.HYPER_SPEED_1:
			component = speed_boost_bar.find_child("HyperSpeed1Component",false,false)
		GameConsts.UPGRADE_LIST.HYPER_SPEED_2:
			component = speed_boost_bar.find_child("HyperSpeed2Component",false,false)
		GameConsts.UPGRADE_LIST.HYPER_SPEED_3:
			component = speed_boost_bar.find_child("HyperSpeed3Component",false,false)
		GameConsts.UPGRADE_LIST.FUEL_1:
			component = speed_boost_bar.find_child("Fuel1Component",false,false)
		GameConsts.UPGRADE_LIST.FUEL_2:
			component = speed_boost_bar.find_child("Fuel2Component",false,false)
		GameConsts.UPGRADE_LIST.FUEL_3:
			component = speed_boost_bar.find_child("Fuel3Component",false,false)
		GameConsts.UPGRADE_LIST.BIG_FRUIT_1:
			component = find_child("BigFruit1Component",false,false)
		GameConsts.UPGRADE_LIST.BIG_FRUIT_2:
			component = find_child("BigFruit2Component",false,false)
		GameConsts.UPGRADE_LIST.BIG_FRUIT_3:
			component = find_child("BigFruit3Component",false,false)
		GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_1:
			component = current_map.find_child("DoubleFruit1Component",false,false)
		GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_2:
			component = current_map.find_child("DoubleFruit2Component",false,false)
		GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_3:
			component = current_map.find_child("DoubleFruit3Component",false,false)
		GameConsts.UPGRADE_LIST.EDGE_WRAP:
			component = current_map.find_child("EdgeWrapComponent",false,false)
		GameConsts.UPGRADE_LIST.DANCE:
			component = current_map.find_child("DanceComponent",false,false)
		GameConsts.UPGRADE_LIST.TAIL_CUT:
			component = current_map.find_child("TailCutComponent",false,false)
		GameConsts.UPGRADE_LIST.STEEL_HELMET:
			component = current_map.snake_head.find_child("SteelHelmetComponent",false,false)
		GameConsts.UPGRADE_LIST.ITEM_RELOADER:
			component = find_child("ItemReloaderComponent",false,false)
		GameConsts.UPGRADE_LIST.KNOT_SLOWMO:
			component = find_child("KnotSlowmo",false,false)
		GameConsts.UPGRADE_LIST.COATING:
			component = find_child("CoatingComponent",false,false)
		GameConsts.UPGRADE_LIST.DIFFUSION:
			component = find_child("DiffusionComponent",false,false)
		GameConsts.UPGRADE_LIST.PIGGY_BANK:
			component = find_child("PiggyBankComponent",false,false)
		GameConsts.UPGRADE_LIST.SALE:
			component = get_parent().shop.find_child("SaleComponent",false,false)
		GameConsts.UPGRADE_LIST.OVERFED:
			component = get_parent().shop.find_child("OverfedComponent",false,false)
		GameConsts.UPGRADE_LIST.CATCH:
			component = find_child("CatchComponent",false,false)
		GameConsts.UPGRADE_LIST.MOULTING:
			component = find_child("MoultingComponent",false,false)
		GameConsts.UPGRADE_LIST.ALLERGY:
			component = find_child("AllergyComponent",false,false)
		GameConsts.UPGRADE_LIST.CORNER_PHASING:
			component = current_map.find_child("CornerPhasingComponent",false,false)
		GameConsts.UPGRADE_LIST.ANCHOR:
			component = current_map.snake_head.find_child("AnchorComponent",false,false)
		GameConsts.UPGRADE_LIST.RUBBER_BAND:
			component = current_map.find_child("RubberBandComponent",false,false)
		GameConsts.UPGRADE_LIST.SWISS_KNIVE:
			component = find_child("SwissKniveComponent",false,false)
		GameConsts.UPGRADE_LIST.PLANT_SNAKE:
			component = current_map.snake_tail.find_child("PlantSnakeComponent",false,false)
		GameConsts.UPGRADE_LIST.SHINY_GHOST:
			component = find_child("ShinyGhostComponent",false,false)
		GameConsts.UPGRADE_LIST.HALF_GONE:
			component = current_map.find_child("HalfGoneComponent",false,false)
		GameConsts.UPGRADE_LIST.POWER_NAP:
			component = find_child("PowerNapComponent",false,false)
	
	if component != null:
		component.self_destruct()
	else:
		print_debug("No Component found to be destroyed")

#decides if the upgrade was attached to an object that reloads on a new act eg map and snake
func is_upgrade_reload_necessary(upgrade_id) -> bool:
	match upgrade_id:
		GameConsts.UPGRADE_LIST.HYPER_SPEED_1,\
		GameConsts.UPGRADE_LIST.HYPER_SPEED_2,\
		GameConsts.UPGRADE_LIST.HYPER_SPEED_3,\
		GameConsts.UPGRADE_LIST.FUEL_1,\
		GameConsts.UPGRADE_LIST.FUEL_2,\
		GameConsts.UPGRADE_LIST.FUEL_3,\
		GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_1,\
		GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_2,\
		GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_3,\
		GameConsts.UPGRADE_LIST.PACMAN_1,\
		GameConsts.UPGRADE_LIST.PACMAN_2,\
		GameConsts.UPGRADE_LIST.PACMAN_3,\
		GameConsts.UPGRADE_LIST.TIME_STOP_1,\
		GameConsts.UPGRADE_LIST.TIME_STOP_2,\
		GameConsts.UPGRADE_LIST.TIME_STOP_3,\
		GameConsts.UPGRADE_LIST.WORMHOLE_1,\
		GameConsts.UPGRADE_LIST.WORMHOLE_2,\
		GameConsts.UPGRADE_LIST.WORMHOLE_3,\
		GameConsts.UPGRADE_LIST.ITEM_RELOADER,\
		GameConsts.UPGRADE_LIST.KNOT_SLOWMO,\
		GameConsts.UPGRADE_LIST.CROSS_ROAD_1,\
		GameConsts.UPGRADE_LIST.CROSS_ROAD_2,\
		GameConsts.UPGRADE_LIST.CROSS_ROAD_3,\
		GameConsts.UPGRADE_LIST.SALE,\
		GameConsts.UPGRADE_LIST.PIGGY_BANK,\
		GameConsts.UPGRADE_LIST.OVERFED,\
		GameConsts.UPGRADE_LIST.SNEK_1,\
		GameConsts.UPGRADE_LIST.SNEK_2,\
		GameConsts.UPGRADE_LIST.SNEK_3,\
		GameConsts.UPGRADE_LIST.BIG_FRUIT_1,\
		GameConsts.UPGRADE_LIST.BIG_FRUIT_2,\
		GameConsts.UPGRADE_LIST.BIG_FRUIT_3,\
		GameConsts.UPGRADE_LIST.SWISS_KNIVE,\
		GameConsts.UPGRADE_LIST.SHINY_GHOST,\
		GameConsts.UPGRADE_LIST.MOULTING,\
		GameConsts.UPGRADE_LIST.POWER_NAP,\
		GameConsts.UPGRADE_LIST.CATCH,\
		GameConsts.UPGRADE_LIST.DIFFUSION,\
		GameConsts.UPGRADE_LIST.ALLERGY:
			return false
		GameConsts.UPGRADE_LIST.FRUIT_MAGNET_1,\
		GameConsts.UPGRADE_LIST.FRUIT_MAGNET_2,\
		GameConsts.UPGRADE_LIST.FRUIT_MAGNET_3,\
		GameConsts.UPGRADE_LIST.DIET_1,\
		GameConsts.UPGRADE_LIST.DIET_2,\
		GameConsts.UPGRADE_LIST.DIET_3,\
		GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_1,\
		GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_2,\
		GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_3,\
		GameConsts.UPGRADE_LIST.MAGIC_FLUTE_1,\
		GameConsts.UPGRADE_LIST.MAGIC_FLUTE_2,\
		GameConsts.UPGRADE_LIST.MAGIC_FLUTE_3,\
		GameConsts.UPGRADE_LIST.EDGE_WRAP,\
		GameConsts.UPGRADE_LIST.TAIL_CUT,\
		GameConsts.UPGRADE_LIST.STEEL_HELMET,\
		GameConsts.UPGRADE_LIST.CORNER_PHASING,\
		GameConsts.UPGRADE_LIST.ANCHOR,\
		GameConsts.UPGRADE_LIST.RUBBER_BAND,\
		GameConsts.UPGRADE_LIST.PLANT_SNAKE,\
		GameConsts.UPGRADE_LIST.DANCE,\
		GameConsts.UPGRADE_LIST.HALF_GONE,\
		GameConsts.UPGRADE_LIST.IMMUTABLE,\
		GameConsts.UPGRADE_LIST.COATING:
			return true
		_:
			print_debug("not determined if upgrade reload necessary for ", upgrade_id)
			return false

func disable_map():
	current_map.process_mode = Node.PROCESS_MODE_DISABLED

func enable_map():
	current_map.process_mode = Node.PROCESS_MODE_INHERIT
	


func _on_test_button_toggled(toggled_on: bool) -> void:
	GameConsts.test_mode = toggled_on
