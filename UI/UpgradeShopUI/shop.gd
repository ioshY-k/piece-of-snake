class_name Shop extends CanvasLayer

signal upgrade_bought
signal upgrade_destroyed
signal finished_buying

const UPGRADE_CARD = preload("res://UI/UpgradeShopUI/UpgradeCards/upgrade_card.tscn")

const BASE_PRICE: int = 4

var fruits_currency: int
@onready var currency_number_label: Label = $ItemShelf/CurrencySymbol/CurrencyNumber
@onready var fruit_count_particle: CPUParticles2D = $FruitCountParticle

var default_slots: Array[Control]
var passive_slots: Array[Control]
var bodymod_slots: Array[Control]
var synergy_slots: Array[Control]
var active_slots: Array[Control]
var special_slots: Array[Control]

var slots: Array[Control] = []
@onready var upgrade_info: Sprite2D = $ItemShelf/UpgradeInfo


var upgrade_card_pool: Array[int] = [
									GameConsts.UPGRADE_LIST.FRUIT_MAGNET_1,
									GameConsts.UPGRADE_LIST.HYPER_SPEED_1,
									GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_1,
									GameConsts.UPGRADE_LIST.EDGE_WRAP_1,
									GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_1,
									GameConsts.UPGRADE_LIST.CROSS_ROAD_1,
									GameConsts.UPGRADE_LIST.TIME_STOP_1,
									GameConsts.UPGRADE_LIST.WORMHOLE_1,
									GameConsts.UPGRADE_LIST.TAIL_CUT,
									GameConsts.UPGRADE_LIST.KNOT_ATTRACTOR,
									GameConsts.UPGRADE_LIST.ITEM_RELOADER,
									GameConsts.UPGRADE_LIST.IMMUTABLE,
									GameConsts.UPGRADE_LIST.CORNER_PHASING]
var default_upgrade_card: int = GameConsts.UPGRADE_LIST.AREA_SIZE_1

@onready var upgrade_overview: Sprite2D = $UpgradeOverview
var purchase_count: int = 1
var current_purchase_count: int

func _ready() -> void:
	if GameConsts.test_mode:
		purchase_count = 3
		upgrade_card_pool= [		GameConsts.UPGRADE_LIST.CROSS_ROAD_1,
									GameConsts.UPGRADE_LIST.CROSS_ROAD_2,
									GameConsts.UPGRADE_LIST.CROSS_ROAD_2,
									GameConsts.UPGRADE_LIST.CROSS_ROAD_3]
	
	current_purchase_count = purchase_count
	
	default_slots = [$UpgradeOverview/UpgradeSlotDefault1]

	passive_slots = [$UpgradeOverview/UpgradeSlotPassive1,
					$UpgradeOverview/UpgradeSlotPassive2,
					$UpgradeOverview/UpgradeSlotPassive3,
					$UpgradeOverview/UpgradeSlotPassive4]
	bodymod_slots = [$UpgradeOverview/UpgradeSlotBodymod1,
					$UpgradeOverview/UpgradeSlot1Bodymod2,
					$UpgradeOverview/UpgradeSlotBodymod3]
	synergy_slots = [$UpgradeOverview/UpgradeSlotSynergy1,
					$UpgradeOverview/UpgradeSlotSynergy2]
	active_slots = [$UpgradeOverview/UpgradeSlotActive1,
					$UpgradeOverview/UpgradeSlotActive2]
	special_slots = [$UpgradeOverview/UpgradeSlotSpecial]
	
	slots.append_array(default_slots)
	slots.append_array(passive_slots)
	slots.append_array(bodymod_slots)
	slots.append_array(synergy_slots)
	slots.append_array(active_slots)
	slots.append_array(special_slots)
		
	hide_shop()

func _on_got_clicked(upgrade_id: int):
	var buy_price = calculate_price(upgrade_id)
	var replace_price = buy_price - 1
	
	if GameConsts.advanced_upgrades.has(upgrade_id):
		for slot in slots:
			if slot.get_node("Area2D").get_child(-1) is UpgradeCard and\
			slot.get_node("Area2D").get_child(-1).upgrade_id == upgrade_id -1:
				slot.get_node("HighlightReplace").visible = true
				slot.get_node("BuyZone").visible = true
				slot.get_node("BuyZone").get_node("Price").text = str(replace_price)
	else:
		var chosen_slots: Array[Control]
		match GameConsts.get_upgrade_type(upgrade_id):
			GameConsts.UPGRADE_TYPE.DEFAULT:
				chosen_slots = default_slots
			GameConsts.UPGRADE_TYPE.PASSIVE:
				chosen_slots = passive_slots
			GameConsts.UPGRADE_TYPE.BODYMOD:
				chosen_slots = bodymod_slots
			GameConsts.UPGRADE_TYPE.SYNERGY:
				chosen_slots = synergy_slots
			GameConsts.UPGRADE_TYPE.ACTIVE:
				chosen_slots = active_slots
			GameConsts.UPGRADE_TYPE.SPECIAL:
				chosen_slots = special_slots
		for slot in chosen_slots:
			if slot.get_node("Area2D").get_child(-1) is UpgradeCard:
				slot.get_node("HighlightReplace").visible = true
				slot.get_node("BuyZone").visible = true
				slot.get_node("BuyZone").get_node("Price").text = str(replace_price)
			else:
				slot.get_node("HighlightBuy").visible = true
				slot.get_node("BuyZone").visible = true
				slot.get_node("BuyZone").get_node("Price").text = str(buy_price)

func calculate_price(upgrade_id):
	if GameConsts.test_mode:
		return 0
	
	var modifier = 0
	
	match GameConsts.get_upgrade_type(upgrade_id):
		GameConsts.UPGRADE_TYPE.DEFAULT:
			modifier -= 3
		GameConsts.UPGRADE_TYPE.PASSIVE:
			modifier -= 1
		GameConsts.UPGRADE_TYPE.BODYMOD:
			pass
		GameConsts.UPGRADE_TYPE.SYNERGY:
			modifier += 1
		GameConsts.UPGRADE_TYPE.ACTIVE:
			modifier -= 1
		GameConsts.UPGRADE_TYPE.SPECIAL:
			modifier += 2
	
	if GameConsts.advanced_upgrades.has(upgrade_id):
		modifier += 2
		if not GameConsts.upgrades_with_advancement.has(upgrade_id):
			modifier += 1
	
	return  BASE_PRICE + modifier
		

func _on_let_go():
	for slot in slots:
		slot.get_node("HighlightReplace").visible = false
		slot.get_node("HighlightBuy").visible = false
		slot.get_node("BuyZone").visible = false

func can_afford(slot):
	return 	int(slot.get_node("BuyZone").get_node("Price").text) <= fruits_currency and\
			current_purchase_count > 0
	
func _on_upgrade_card_bought(upgrade_id: int, slot) -> void:
	current_purchase_count -= 1
	fruits_currency -= int(slot.get_node("BuyZone").get_node("Price").text)
	currency_number_label.text = str(fruits_currency)
	update_upgrade_pool(upgrade_id, true)
	upgrade_bought.emit(upgrade_id)

func _on_upgrade_destroyed(upgrade_id: int) -> void:
	if GameConsts.upgrades_with_advancement.has(upgrade_id):
		update_upgrade_pool(upgrade_id, false)
	upgrade_destroyed.emit(upgrade_id)




func update_upgrade_pool(upgrade_id: int, bought_not_destroyed: bool):
	if bought_not_destroyed:
		upgrade_card_pool.erase(upgrade_id)
		if GameConsts.upgrades_with_advancement.has(upgrade_id):
			if upgrade_id == GameConsts.UPGRADE_LIST.AREA_SIZE_1:
				default_upgrade_card = GameConsts.UPGRADE_LIST.AREA_SIZE_2
			elif upgrade_id == GameConsts.UPGRADE_LIST.AREA_SIZE_2:
					default_upgrade_card = GameConsts.UPGRADE_LIST.AREA_SIZE_3
			else:
				upgrade_card_pool.append(upgrade_id + 1)
	else:
		upgrade_card_pool.erase(upgrade_id+1)
		
		
			

func _on_continue_next_round_pressed() -> void:
	current_purchase_count = purchase_count
	var shelf_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
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
		
	
	var itemcounter: int = 0
	var itemslots: Array[Sprite2D] = [$ItemShelf/Itemslot1, $ItemShelf/Itemslot2, $ItemShelf/Itemslot3]
	for offered_upgrade in offered_upgrades:
		var offset_vector: Vector2 = Vector2(randi_range(-170,170), randi_range(-170,170))
		var upgrade_card = UPGRADE_CARD.instantiate()
		$ItemShelf.add_child(upgrade_card)
		upgrade_card.instantiate_upgrade_card( offered_upgrade )
		var card_tween = create_tween()
		card_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
		card_tween.tween_property(upgrade_card, "position" ,itemslots[itemcounter].position + offset_vector, 0.2 + itemcounter * 0.1)
		card_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
		card_tween.tween_property(upgrade_card, "position", itemslots[itemcounter].position, 0.4)
		itemcounter += 1
		await card_tween.finished
		card_tween.stop()
	toggle_upgrade_panel()

func reset_area_and_currency():
	fruits_currency = 0
	currency_number_label.text = str(fruits_currency)
	
	var default_upgrade = default_slots[0].get_node("Area2D").get_child(-1)
	if default_upgrade is UpgradeCard:
		default_upgrade.destroyed.emit(default_upgrade.upgrade_id)
		default_upgrade.queue_free()
	default_upgrade_card = GameConsts.UPGRADE_LIST.AREA_SIZE_1

func show_shop():
	$ItemShelf.show()
	upgrade_info.hide()
	$ItemShelf.rotation_degrees = -180
	var shelf_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	shelf_tween.tween_property($ItemShelf, "rotation_degrees", 0, 0.8)
	await  shelf_tween.finished

func hide_shop():
	if upgrades_expanded:
		toggle_upgrade_panel()
	$ItemShelf.hide()


var upgrades_expanded: bool = false
func toggle_upgrade_panel() -> void:
	var tween = create_tween()
	if not upgrades_expanded:
		tween.tween_property(upgrade_overview, "position:x", 210, 0.4).\
		set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
		upgrades_expanded = true
	else:
		tween.tween_property(upgrade_overview, "position:x", -425, 0.4).\
		set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		upgrades_expanded = false
