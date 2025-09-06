class_name Shop extends CanvasLayer


signal upgrade_destroyed
signal finished_buying
signal upgrade_cards_instantiated

var moulted: bool = false
var reroll_cost_start_number: int = 1
var reroll_cost_number: int = 1

const UPGRADE_CARD = preload("res://Shop/UpgradeCards/upgrade_card.tscn")

const BASE_PRICE: int = 4

@onready var run_manager: RunManager = get_parent()
var fruits_currency: int
@onready var currency_number_label: Label = $ItemShelf/CurrencySymbol/CurrencyNumber
@onready var fruit_count_particle: CPUParticles2D = $FruitCountParticle

@onready var deal_area_size: Button = $ItemShelf/DealAreaSize
@onready var deal_new_cards: Button = $ItemShelf/DealNewCards
@onready var reroll_cost_label: Label = $ItemShelf/DealNewCards/RerollCost


var default_slots: Array[Control]
var passive_slots: Array[Control]
var bodymod_slots: Array[Control]
var synergy_slots: Array[Control]
var active_slots: Array[Control]
var special_slots: Array[Control]

@onready var items_shop_lots: Array[Sprite2D] = [	$ItemShelf/Itemslot1,
													$ItemShelf/Itemslot2,
													$ItemShelf/Itemslot3]

var slots: Array[Control] = []
@onready var upgrade_info: Sprite2D = $ItemShelf/UpgradeInfo
@onready var item_shelf: ItemShelf = $ItemShelf


var upgrade_card_pool: Array[int] = [
									GameConsts.UPGRADE_LIST.FRUIT_MAGNET_1,
									GameConsts.UPGRADE_LIST.HYPER_SPEED_1,
									GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_1,
									GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_1,
									GameConsts.UPGRADE_LIST.CROSS_ROAD_1,
									GameConsts.UPGRADE_LIST.TIME_STOP_1,
									GameConsts.UPGRADE_LIST.WORMHOLE_1,
									GameConsts.UPGRADE_LIST.TAIL_CUT,
									GameConsts.UPGRADE_LIST.KNOT_SLOWMO,
									GameConsts.UPGRADE_LIST.ITEM_RELOADER,
									GameConsts.UPGRADE_LIST.CORNER_PHASING,
									GameConsts.UPGRADE_LIST.PIGGY_BANK,
									GameConsts.UPGRADE_LIST.SALE,
									GameConsts.UPGRADE_LIST.DIET_1,
									GameConsts.UPGRADE_LIST.COATING,
									GameConsts.UPGRADE_LIST.STEEL_HELMET,
									GameConsts.UPGRADE_LIST.FUEL_1,
									GameConsts.UPGRADE_LIST.RUBBER_BAND,
									GameConsts.UPGRADE_LIST.SWISS_KNIVE,
									GameConsts.UPGRADE_LIST.MAGIC_FLUTE_1,
									GameConsts.UPGRADE_LIST.PACMAN_1,
									GameConsts.UPGRADE_LIST.SHINY_GHOST,
									GameConsts.UPGRADE_LIST.PLANT_SNAKE,
									GameConsts.UPGRADE_LIST.SNEK_1,
									GameConsts.UPGRADE_LIST.BIG_FRUIT_1,
									GameConsts.UPGRADE_LIST.CATCH,
									GameConsts.UPGRADE_LIST.POWER_NAP]
var special_upgrade_card_pool: Array[int] = [
									GameConsts.UPGRADE_LIST.EDGE_WRAP,
									GameConsts.UPGRADE_LIST.IMMUTABLE,
									GameConsts.UPGRADE_LIST.MOULTING,
									GameConsts.UPGRADE_LIST.ANCHOR,
									GameConsts.UPGRADE_LIST.DANCE,
									GameConsts.UPGRADE_LIST.HALF_GONE,
									GameConsts.UPGRADE_LIST.ALLERGY,
									GameConsts.UPGRADE_LIST.OVERFED,
											]
var default_upgrade_card: int = GameConsts.UPGRADE_LIST.AREA_SIZE_1

@onready var upgrade_overview: Sprite2D = $UpgradeOverview

@onready var card_deal_audio: AudioStreamPlayer = $CardDealAudio
@onready var button_press_audio: AudioStreamPlayer = $ButtonPressAudio

func _ready() -> void:
	if GameConsts.test_mode:
		upgrade_card_pool= [			GameConsts.UPGRADE_LIST.OVERFED,
									GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_1,
									GameConsts.UPGRADE_LIST.HALF_GONE,]	
	
	reroll_cost_label.text = str(reroll_cost_number)
	
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

func initiate_map_preview(maporder: Array):
	if maporder.size() != 3:
		print_debug("not 3 maps or 3 previews")
		return
	for index in range(len(maporder)):
		item_shelf.set_map_preview(index, maporder[index])

func update_map_preview(current_act):
	item_shelf.set_map_covering(current_act)

func _on_got_clicked(upgrade_card: UpgradeCard):
	
	var upgrade_id = upgrade_card.upgrade_id
	var buy_price = upgrade_card.price
	var replace_price = buy_price - 1
	
	if GameConsts.advanced_upgrades.has(upgrade_id):
		for slot in slots:
			if is_filled(slot) and\
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
			if is_filled(slot):
				if slot.get_node("Area2D").get_child(-1).card_sprite.frame != GameConsts.UPGRADE_LIST.DEAD_MOUSE:
					slot.get_node("HighlightReplace").visible = true
					slot.get_node("BuyZone").visible = true
					slot.get_node("BuyZone").get_node("Price").text = str(replace_price)
			else:
				slot.get_node("HighlightBuy").visible = true
				slot.get_node("BuyZone").visible = true
				slot.get_node("BuyZone").get_node("Price").text = str(buy_price)

func _on_let_go():
	for slot in slots:
		slot.get_node("HighlightReplace").visible = false
		slot.get_node("HighlightBuy").visible = false
		slot.get_node("BuyZone").visible = false

func select_random_upgrade(type):
	upgrade_card_pool.shuffle()
	for upgrade in upgrade_card_pool:
		if GameConsts.get_upgrade_type(upgrade) == type:
			return upgrade

func can_afford(slot):
	if slot.get_node("Area2D").get_child(-1) is UpgradeCard and\
	slot.get_node("Area2D").get_child(-1).card_sprite.frame == GameConsts.UPGRADE_LIST.DEAD_MOUSE:
		return false
	return 	int(slot.get_node("BuyZone").get_node("Price").text) <= fruits_currency

func _on_upgrade_card_bought(upgrade_id: int, slot) -> void:
	fruits_currency -= int(slot.get_node("BuyZone").get_node("Price").text)
	currency_number_label.text = str(fruits_currency)
	update_upgrade_pool(upgrade_id, true)
	deal_area_size.disabled = true
	if not moulted:
		deal_new_cards.disabled = true
	SignalBus.upgrade_bought.emit(upgrade_id)
	

func _on_upgrade_destroyed(upgrade_id: int) -> void:
	if GameConsts.upgrades_with_advancement.has(upgrade_id):
		update_upgrade_pool(upgrade_id, false)
	upgrade_destroyed.emit(upgrade_id)

func equip_item(upgrade_id, slot_type):
	var no_space: bool = true
	var free_slot
	for slot in slot_type:
		if not is_filled(slot):
			free_slot = slot
			no_space = false
			break
	if no_space:
		return
	var upgrade_card: UpgradeCard = UPGRADE_CARD.instantiate()
	free_slot.get_node("Area2D").add_child(upgrade_card)
	upgrade_card.instantiate_upgrade_card(upgrade_id)
	upgrade_card.is_bought = true
	upgrade_card.owned_slot_area = free_slot.get_node("Area2D")
	await get_tree().process_frame
	upgrade_card._snap_to_slot(free_slot.get_node("Area2D"))
	update_upgrade_pool(upgrade_id, true)
	SignalBus.upgrade_bought.emit(upgrade_id)
	
	

func is_filled(slot):
	return slot.get_node("Area2D").get_child(-1) is UpgradeCard

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
	#called for upgrades with advancements, so that the advancement leaves the pool
	else:
		upgrade_card_pool.erase(upgrade_id+1)
		
		
			

func _on_continue_next_round_pressed() -> void:
	button_press_audio.play()
	var shelf_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	shelf_tween.tween_property($ItemShelf, "rotation_degrees", -180, 0.8)
	await  shelf_tween.finished
	for upgrade_card in get_tree().get_nodes_in_group("UpgradeCard"):
		if not upgrade_card.is_bought:
			upgrade_card.queue_free()
	deal_area_size.disabled = false
	deal_new_cards.disabled = false
	finished_buying.emit()

func generate_items(current_round):
	upgrade_card_pool.shuffle()
	special_upgrade_card_pool.shuffle()
	var offered_upgrades: Array[int] = []
	
	if current_round == 3:
		var advanced_upgrades: Array[int] = []
		for upgrade_id in range(run_manager.current_upgrades.size()):
			if run_manager.current_upgrades[upgrade_id] and GameConsts.upgrades_with_advancement.has(upgrade_id) and\
			not(upgrade_id == 0 or upgrade_id == 1):
				advanced_upgrades.append(upgrade_id+1)
			advanced_upgrades.shuffle()
		
		for i in range(2):
			if advanced_upgrades.size() > 0:
				offered_upgrades.append(advanced_upgrades.pop_front())
			else:
				offered_upgrades.append(upgrade_card_pool[i])
		offered_upgrades.append(special_upgrade_card_pool[0])
	else:
		offered_upgrades.append(upgrade_card_pool[0])
		offered_upgrades.append(upgrade_card_pool[1])
		offered_upgrades.append(upgrade_card_pool[2])
	deal_upgrade_cards(offered_upgrades)
	
func deal_upgrade_cards(offered_upgrades: Array[int]):
	var itemcounter: int = 0
	var card_tween: Tween
	card_deal_audio.play()
	for offered_upgrade in offered_upgrades:
		var offset_vector: Vector2 = Vector2(randi_range(-170,170), randi_range(-170,170))
		var upgrade_card = UPGRADE_CARD.instantiate()
		$ItemShelf.add_child(upgrade_card)
		upgrade_card.instantiate_upgrade_card( offered_upgrade )
		card_tween = create_tween()
		card_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
		card_tween.tween_property(upgrade_card, "position" ,items_shop_lots[itemcounter].position + offset_vector, 0.2 + itemcounter * 0.1)
		card_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
		card_tween.tween_property(upgrade_card, "position", items_shop_lots[itemcounter].position, 0.4)
		itemcounter += 1
	upgrade_cards_instantiated.emit()
	await card_tween.finished
	card_tween.stop()
	if not upgrades_expanded:
		toggle_upgrade_panel()

func reset_area_and_currency():
	reroll_cost_number = reroll_cost_start_number
	reroll_cost_label.text = str(reroll_cost_number)
	if RunSettings.current_char != GameConsts.CHAR_LIST.ELEPHANT:
		fruits_currency = 0
		currency_number_label.text = str(fruits_currency)
	
	var default_upgrade = default_slots[0].get_node("Area2D").get_child(-1)
	if default_upgrade is UpgradeCard:
		default_upgrade.destroyed.emit(default_upgrade.upgrade_id)
		default_upgrade.queue_free()
	default_upgrade_card = GameConsts.UPGRADE_LIST.AREA_SIZE_1

func show_shop() -> Tween:
	$ItemShelf.show()
	upgrade_info.hide()
	if run_manager.current_round == 3:
		deal_area_size.hide()
		deal_area_size.disabled = true
	else:
		deal_area_size.show()
		deal_area_size.disabled = false
	$ItemShelf.rotation_degrees = -180
	var shelf_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	shelf_tween.tween_property($ItemShelf, "rotation_degrees", 0, 0.8)
	return shelf_tween

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


func _on_continue_next_round_mouse_entered() -> void:
	var upcoming_mapmod = run_manager.mapmodorder[run_manager.current_round+1]
	item_shelf.show_mapmod_description(upcoming_mapmod)


func _on_continue_next_round_mouse_exited() -> void:
	item_shelf.hide_mapmod_description()


func _on_deal_area_size_pressed() -> void:
	for upgrade_card in get_node("ItemShelf").get_children():
		if upgrade_card is UpgradeCard:
			upgrade_card.queue_free()
	deal_upgrade_cards([default_upgrade_card])

func _on_deal_new_cards_pressed() -> void:
	if fruits_currency >= reroll_cost_number:
		fruits_currency -= reroll_cost_number
		currency_number_label.text = str(fruits_currency)
		reroll_cost_number += 1
		reroll_cost_label.text = str(reroll_cost_number)
		for upgrade_card in get_node("ItemShelf").get_children():
			if upgrade_card is UpgradeCard:
				upgrade_card.queue_free()
		generate_items(run_manager.current_round)
