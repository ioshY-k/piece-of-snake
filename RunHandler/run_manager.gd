extends Node

var maps_act1 = [0,1]
var maps_act2 = [2,3]
var maps_act3 = [4,5]
var maporder = []
										
@onready var retry_button: Button = $RetryButton

var current_round: int = 0
var current_act: int = 0

@onready var shop: Shop = $Shop

var level_scene: PackedScene = preload("res://Levels/level.tscn")
var level: LevelManager

var current_upgrades: Array[bool] = []


func _ready() -> void:
	current_upgrades.resize(30)
	current_upgrades.fill(false)
	
	create_new_run()
	
	shop.upgrade_bought.connect(_on_upgrade_bought)
	shop.upgrade_destroyed.connect(_on_upgrade_destroyed)
	

func create_new_run():
	maporder = [maps_act1[randi()%maps_act1.size()],
				maps_act2[randi()%maps_act2.size()],
				maps_act3[randi()%maps_act3.size()]]
	#test purpose
	maporder = [4,1,0]
		
	level = level_scene.instantiate()
	add_child(level)
	level.prepare_new_act(maporder[current_act], GameConsts.FRUIT_THRESHOLDS[current_act*4 + current_round], GameConsts.ROUND_TIME_SEC)
	SignalBus.round_over.connect(_on_round_over)

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
		shop.fruit_count_particle.emitting = true
		while level.fruits_overload > 0:
			level.fruits_overload -= 1
			shop.fruit_count_particle.position = Vector2(300,85)
			var tween = create_tween().tween_property(shop.fruit_count_particle, "position", Vector2(1650,130), 0.5)
			await tween.finished
			shop.fruits_currency += 1
			var currency_label_tween = create_tween()
			currency_label_tween.tween_property(shop.currency_number_label, "scale", Vector2(1.6,1.6), 0.06)
			currency_label_tween.tween_property(shop.currency_number_label, "scale", Vector2(1,1), 0.06)
			shop.currency_number_label.text = str(shop.fruits_currency)
			level.fruits_left_number_label.text = str(level.fruits_overload)
		shop.fruit_count_particle.emitting = false
		await get_tree().create_timer(0.5).timeout
		
		shop.generate_items(current_round)
		
		await shop.finished_buying
		
		
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
