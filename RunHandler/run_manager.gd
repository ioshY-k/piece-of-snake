class_name RunManager extends Node

var scene_loader

var maps_act1 = [
	GameConsts.MAP_LIST.STADIUM
	#GameConsts.MAP_LIST.STADIUM,GameConsts.MAP_LIST.RESTAURANT
	]
var maps_act2 = [
	#GameConsts.MAP_LIST.OFFICE,
	GameConsts.MAP_LIST.CAVE]
var maps_act3 = [GameConsts.MAP_LIST.DISCO,GameConsts.MAP_LIST.BEACH]
var maporder = []
var mapmodorder = []
var fruit_thresholds = GameConsts.FRUIT_THRESHOLDS
										
@onready var retry_button: Button = $RetryButton

var current_round: int = 0
var current_act: int = 0

@onready var shop: Shop = $Shop

var level_scene: PackedScene = preload("res://Level/level.tscn")
var level: LevelManager

var current_upgrades: Array[bool] = []

@onready var fruit_payout_audio: AudioStreamPlayer = $FruitPayoutAudio

func _ready() -> void:
	scene_loader = get_parent()
	
	current_upgrades.resize(61)
	current_upgrades.fill(false)
	
	shop.upgrade_bought.connect(_on_upgrade_bought)
	shop.upgrade_destroyed.connect(_on_upgrade_destroyed)
	
	create_new_run()
	shop.initiate_map_preview(maporder)


func create_new_run():
	maporder = [maps_act1[randi()%maps_act1.size()],
				maps_act2[randi()%maps_act2.size()],
				maps_act3[randi()%maps_act3.size()]]
	
	for i in range(3):
		var mods = GameConsts.MAP_MODS.values()
		mods.shuffle()
		mapmodorder.append_array(mods)
	
	if RunSettings.current_char == GameConsts.CHAR_LIST.PYTHON:
		for index in range(fruit_thresholds.size()-1):
			fruit_thresholds[index] -= 1
	
	if GameConsts.test_mode:
		maporder = [GameConsts.MAP_LIST.DISCO,
					GameConsts.MAP_LIST.CAVE,
					GameConsts.MAP_LIST.TOMB]
		mapmodorder = [GameConsts.MAP_MODS.LASER,
						GameConsts.MAP_MODS.LASER,
						GameConsts.MAP_MODS.LASER,
						GameConsts.MAP_MODS.LASER,
						GameConsts.MAP_MODS.GHOST_INVASION,
						GameConsts.MAP_MODS.CAFFEINATED,
						GameConsts.MAP_MODS.LASER,
						GameConsts.MAP_MODS.LASER,
						GameConsts.MAP_MODS.LASER,
						GameConsts.MAP_MODS.LASER,
						GameConsts.MAP_MODS.LASER,
						GameConsts.MAP_MODS.TETRI_FRUIT]

	level = level_scene.instantiate()
	add_child(level)
	level.prepare_new_act(maporder[current_act], fruit_thresholds[current_act*4 + current_round], GameConsts.ROUND_TIME_SEC, mapmodorder[current_act*4 + current_round])
	if RunSettings.current_char == GameConsts.CHAR_LIST.SALAMANDER:
		var random_active_upgrade: int = shop.select_random_upgrade(GameConsts.UPGRADE_TYPE.ACTIVE)
		shop.equip_item(random_active_upgrade, shop.active_slots)
	
	SignalBus.round_over.connect(_on_round_over)

func _on_upgrade_bought(upgrade: int):
	current_upgrades[upgrade] = true
	level.instantiate_upgrade(upgrade)

func _on_upgrade_destroyed(upgrade: int):
	current_upgrades[upgrade] = false
	level.destroy_upgrade(upgrade)
	
	
func _on_round_over():
	if level.fruits_left > 0:
		scene_loader.change_scene("MAIN_MENU")
	else:
		level.disable_map()
		
		shop.update_map_preview(current_act)
		var shelf_tween:Tween = shop.show_shop()
		await shelf_tween.finished
		await get_tree().create_timer(0.5).timeout
		shop.fruit_count_particle.emitting = true
		while level.fruits_overload > 0:
			level.fruits_overload -= 1
			shop.fruit_count_particle.position = Vector2(300,85)
			var tween = create_tween().tween_property(shop.fruit_count_particle, "global_position", shop.currency_number_label.global_position + Vector2(100,150), 0.27)
			await tween.finished
			shop.fruits_currency += 1
			var currency_label_tween = create_tween()
			currency_label_tween.tween_property(shop.currency_number_label, "scale", Vector2(1.6,1.6), 0.06)
			currency_label_tween.tween_property(shop.currency_number_label, "scale", Vector2(1,1), 0.06)
			shop.currency_number_label.text = str(shop.fruits_currency)
			level.fruits_left_number_label.text = str(level.fruits_overload)
			fruit_payout_audio.play()
		shop.fruit_count_particle.emitting = false
		await get_tree().create_timer(0.5).timeout
		
		shop.generate_items(current_round)
		
		await shop.finished_buying
		
		
		shop.hide_shop()
		if current_round < 3:
			current_round += 1
			level.prepare_new_round(fruit_thresholds[current_act*4 + current_round], GameConsts.ROUND_TIME_SEC, mapmodorder[current_act*4 + current_round])
		else:
			SignalBus.act_over.emit()
			current_act += 1
			current_round = 0
			shop.reset_area_and_currency()
			level.prepare_new_act(maporder[current_act], fruit_thresholds[current_act*4 + current_round], GameConsts.ROUND_TIME_SEC, mapmodorder[current_act*4 + current_round])


func _on_retry_button_pressed() -> void:
	for child in get_children():
		if child.name == "Level":
			return
		
	create_new_run()
