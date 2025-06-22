class_name Shop extends CanvasLayer

signal upgrade_bought
signal finished_buying

const UPGRADE_CARD = preload("res://UI/UpgradeShopUI/UpgradeCards/upgrade_card.tscn")

var upgrade_card_pool: Array[int] = [
									GameConsts.UPGRADE_LIST.FRUIT_MAGNET_1,
									GameConsts.UPGRADE_LIST.HYPER_SPEED_1,
									GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_1,
									GameConsts.UPGRADE_LIST.EDGE_WRAP_1,
									GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_1,
									GameConsts.UPGRADE_LIST.CROSS_ROAD_1,
									GameConsts.UPGRADE_LIST.TAIL_CUT,
									GameConsts.UPGRADE_LIST.KNOT_ATTRACTOR,
									GameConsts.UPGRADE_LIST.ITEM_RELOADER,
									GameConsts.UPGRADE_LIST.IMMUTABLE]
var default_upgrade_card: int = GameConsts.UPGRADE_LIST.AREA_SIZE_1

@onready var upgrade_panel_button: Button = $UpgradeOverview/UpgradePanelButton
@onready var upgrade_overview: Sprite2D = $UpgradeOverview

func _ready() -> void:
	hide_shop()

func _on_upgrade_card_bought(upgrade_id: int) -> void:
	print(upgrade_id)
	print(upgrade_card_pool)
	update_upgrade_pool(upgrade_id)
	print(upgrade_card_pool)
			
	upgrade_bought.emit(upgrade_id)

func update_upgrade_pool(upgrade_id: int):
	
	upgrade_card_pool.erase(upgrade_id)
	
	if GameConsts.get_upgrade_type(upgrade_id) == GameConsts.UPGRADE_TYPE.PASSIVE or\
	GameConsts.get_upgrade_type(upgrade_id) == GameConsts.UPGRADE_TYPE.ACTIVE or\
	GameConsts.get_upgrade_type(upgrade_id) == GameConsts.UPGRADE_TYPE.DEFAULT:
		match upgrade_id:
			GameConsts.UPGRADE_LIST.AREA_SIZE_1:
				default_upgrade_card = GameConsts.UPGRADE_LIST.AREA_SIZE_2
			GameConsts.UPGRADE_LIST.AREA_SIZE_2:
				default_upgrade_card = GameConsts.UPGRADE_LIST.AREA_SIZE_3
				
			GameConsts.UPGRADE_LIST.FRUIT_MAGNET_1:
				upgrade_card_pool.append(GameConsts.UPGRADE_LIST.FRUIT_MAGNET_2)
			GameConsts.UPGRADE_LIST.FRUIT_MAGNET_2:
				upgrade_card_pool.append(GameConsts.UPGRADE_LIST.FRUIT_MAGNET_3)
			GameConsts.UPGRADE_LIST.HYPER_SPEED_1:
				upgrade_card_pool.append(GameConsts.UPGRADE_LIST.HYPER_SPEED_2)
			GameConsts.UPGRADE_LIST.HYPER_SPEED_2:
				upgrade_card_pool.append(GameConsts.UPGRADE_LIST.HYPER_SPEED_3)
			GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_1:
				upgrade_card_pool.append(GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_2)
			GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_2:
				upgrade_card_pool.append(GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_3)
			GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_1:
				upgrade_card_pool.append(GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_2)
			GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_2:
				upgrade_card_pool.append(GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_3)
			GameConsts.UPGRADE_LIST.CROSS_ROAD_1:
				upgrade_card_pool.append(GameConsts.UPGRADE_LIST.CROSS_ROAD_2)
			GameConsts.UPGRADE_LIST.CROSS_ROAD_2:
				upgrade_card_pool.append(GameConsts.UPGRADE_LIST.CROSS_ROAD_3)
			_:
				pass
				

func _on_continue_next_round_pressed() -> void:
	var shelf_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	shelf_tween.tween_property($ItemShelf, "rotation_degrees", -180, 0.8)
	await  shelf_tween.finished
	for upgrade_card in get_tree().get_nodes_in_group("UpgradeCard"):
		if not upgrade_card.is_bought:
			upgrade_card.queue_free()
	finished_buying.emit()

func generate_items(current_round):
	upgrade_card_pool.shuffle()
	var offered_upgrades: Array[int]
	
	if current_round == 3:
		offered_upgrades = [upgrade_card_pool[0],upgrade_card_pool[1],upgrade_card_pool[2]]
	else:
		offered_upgrades = [default_upgrade_card, upgrade_card_pool[0], upgrade_card_pool[1]]
		
	$ItemShelf.rotation_degrees = -180
	var shelf_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	shelf_tween.tween_property($ItemShelf, "rotation_degrees", 0, 0.8)
	await  shelf_tween.finished
	
	var card_tween = create_tween()
	var itemcounter: int = 0
	var itemslots: Array[Sprite2D] = [$ItemShelf/Itemslot1, $ItemShelf/Itemslot2, $ItemShelf/Itemslot3]
	for offered_upgrade in offered_upgrades:
		var offset_vector: Vector2 = Vector2(randi_range(20,100), randi_range(20,100))
		var upgrade_card = UPGRADE_CARD.instantiate()
		$ItemShelf.add_child(upgrade_card)
		upgrade_card.instantiate_upgrade_card( offered_upgrade )
		card_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
		card_tween.tween_property(upgrade_card, "position" ,itemslots[itemcounter].position + offset_vector, 0.2 + itemcounter * 0.1)
		card_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
		card_tween.tween_property(upgrade_card, "position", itemslots[itemcounter].position, 0.4)
		itemcounter += 1
	if not upgrades_expanded:
		await card_tween.finished

		_on_upgrade_panel_button_mouse_entered()

func show_shop():
	$ContinueNextRound.show()
	$FruitOverloadInfo.show()
	$ItemShelf.show()

func hide_shop():
	$ContinueNextRound.hide()
	$FruitOverloadInfo.hide()
	$ItemShelf.hide()
	

var upgrades_expanded: bool = false
func _on_upgrade_panel_button_mouse_entered() -> void:
	var tween = create_tween()
	if not upgrades_expanded:
		tween.tween_property(upgrade_overview, "position:x", 360, 0.4).\
		set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(upgrade_panel_button, "rotation_degrees", 180, 0.25).\
		set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
		upgrades_expanded = true
	else:
		tween.tween_property(upgrade_overview, "position:x", -388, 0.4).\
		set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(upgrade_panel_button, "rotation_degrees", 0, 0.25).\
		set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
		upgrades_expanded = false
