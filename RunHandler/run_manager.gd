extends Node


var maporder = [0,1,2]
										
@onready var retry_button: Button = $RetryButton

var current_round: int = 0
var current_act: int = 0

@onready var shop: Shop = $Shop

var level_scene: PackedScene = preload("res://Levels/level.tscn")
var level: LevelManager

var current_upgrades: Array[bool] = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]


func _ready() -> void:
	create_new_run()
	
	shop.upgrade_bought.connect(_on_upgrade_bought)
	shop.upgrade_destroyed.connect(_on_upgrade_destroyed)
	

func create_new_run():
	maporder.shuffle()
		
	maporder = [2,2,2]
		
	level = level_scene.instantiate()
	add_child(level)
	level.prepare_new_act(maporder[current_act], GameConsts.FRUIT_THRESHOLDS[current_act*4 + current_round], GameConsts.ROUND_TIME_SEC)
	level.round_over.connect(_on_round_over)

func _on_upgrade_bought(upgrade: int):
	current_upgrades[upgrade] = true
	level.instantiate_upgrade(upgrade)

func _on_upgrade_destroyed(upgrade: int):
	current_upgrades[upgrade] = false
	level.destroy_upgrade(upgrade)
	
	
func _on_round_over():
	if level.fruits_left > 0:
		level.queue_free()
	else:
		level.disable_map()
		
		shop.show_shop()
		await get_tree().create_timer(0.5).timeout
		while level.fruits_overload > 0:
			await get_tree().create_timer(0.5).timeout
			level.fruits_overload -= 1
			shop.fruits_currency += 1
			shop.currency_number_label.text = str(shop.fruits_currency)
			level.fruits_left_number_label.text = str(level.fruits_overload)
		await get_tree().create_timer(0.5).timeout
		
		shop.generate_items(current_round)
		
		await shop.finished_buying
		
		
		level.enable_map()
		shop.hide_shop()
		if current_round < 3:
			current_round += 1
			level.prepare_new_round(GameConsts.FRUIT_THRESHOLDS[current_act*4 + current_round], GameConsts.ROUND_TIME_SEC)
		else:
			current_act += 1
			current_round = 0
			shop.reset_area_and_currency()
			current_upgrades[0]
			current_upgrades[1]
			current_upgrades[2]
			level.prepare_new_act(maporder[current_act], GameConsts.FRUIT_THRESHOLDS[current_act*4 + current_round], GameConsts.ROUND_TIME_SEC)


func _on_retry_button_pressed() -> void:
	for child in get_children():
		if child.name == "Level":
			return
		
	create_new_run()
