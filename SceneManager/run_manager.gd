extends Node

var maporder: Array[PackedScene] = [preload("res://Levels/Map1/square_map.tscn"),
									preload("res://Levels/Map2/big_map.tscn")
									]
										
@onready var retry_button: Button = $RetryButton

var current_round: int = 0
var current_act: int = 0

var shop_scene: PackedScene = preload("res://UI/UpgradeShopUI/shop.tscn")
var shop: Shop
var level_scene: PackedScene = preload("res://Levels/level.tscn")
var level: LevelManager

func _ready() -> void:
	shop = shop_scene.instantiate()
	add_child(shop)
	shop.hide()
	create_new_run()
	

func create_new_run():
	maporder.shuffle()
	level = level_scene.instantiate()
	add_child(level)
	level.prepare_new_act(maporder[current_act].instantiate(), GameConsts.FRUIT_THRESHOLDS[current_act*4 + current_round], GameConsts.ROUND_TIME_SEC)
	level.round_over.connect(_on_round_over)


	
func _on_round_over():
	if level.fruits_left > 0:
		print("GAME OVER")
		level.queue_free()
	else:
		print("Overstock collected: " + str(abs(level.fruits_left)))
		if current_round < 3:
			current_round += 1
			print("NEXT ROUND")
			shop.show()
			level.process_mode = Node.PROCESS_MODE_DISABLED
			await shop.upgrade_chosen
			level.process_mode = Node.PROCESS_MODE_INHERIT
			shop.hide()
			level.prepare_new_round(GameConsts.FRUIT_THRESHOLDS[current_act*4 + current_round], GameConsts.ROUND_TIME_SEC)
		else:
			current_act += 1
			current_round = 0
			print("NEXT LEVEL")
			level.prepare_new_act(maporder[current_act].instantiate(), GameConsts.FRUIT_THRESHOLDS[current_act*4 + current_round], GameConsts.ROUND_TIME_SEC)


func _on_retry_button_pressed() -> void:
	create_new_run()
