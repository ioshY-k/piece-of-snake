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

@onready var deal_new_cards: TextureButton = $ItemShelf/DealNewCards
@onready var skip_mapspace: TextureButton = $ItemShelf/SkipMapspace
@onready var reroll_cost_label: Label = $ItemShelf/DealNewCards/RerollCost


var default_slots: Array[Control]
var passive_slots: Array[Control]
var bodymod_slots: Array[Control]
var synergy_slots: Array[Control]
var active_slots: Array[Control]
var special_slots: Array[Control]
var rainbow_slots: Array[Control]

@onready var items_shop_slots: Array[Sprite2D] = [	$ItemShelf/Itemslot1,
													$ItemShelf/Itemslot2,
													$ItemShelf/Itemslot3]

var slots: Array[Control] = []
@onready var upgrade_info: Node2D = $ItemShelf/UpgradeInfo
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
									GameConsts.UPGRADE_LIST.HEAD_LIGHT,
									GameConsts.UPGRADE_LIST.SNEK_1,
									GameConsts.UPGRADE_LIST.BIG_FRUIT_1,
									GameConsts.UPGRADE_LIST.CATCH,
									GameConsts.UPGRADE_LIST.DIFFUSION,
									GameConsts.UPGRADE_LIST.POWER_NAP,
									GameConsts.UPGRADE_LIST.DRAGONFLY_1,
									GameConsts.UPGRADE_LIST.MAYFLY_1,
									GameConsts.UPGRADE_LIST.BUMBLEBEE_1,
									GameConsts.UPGRADE_LIST.TONGUE_1,
									GameConsts.UPGRADE_LIST.FRUIT_AREA_1,
									GameConsts.UPGRADE_LIST.HIT_ACTION,
									GameConsts.UPGRADE_LIST.GHOST_FRUIT_REACTION,
									GameConsts.UPGRADE_LIST.INSECT_REACTION,
									GameConsts.UPGRADE_LIST.SHRINK_REACTION,
									GameConsts.UPGRADE_LIST.INSECT_ACTION,
									GameConsts.UPGRADE_LIST.ACTIVE_ITEM_ACTION,
									GameConsts.UPGRADE_LIST.CARNIVORE
									]
var special_upgrade_card_pool: Array[int] = [
									GameConsts.UPGRADE_LIST.IMMUTABLE,
									GameConsts.UPGRADE_LIST.MOULTING,
									GameConsts.UPGRADE_LIST.EDGE_WRAP,
									GameConsts.UPGRADE_LIST.DANCE,
									GameConsts.UPGRADE_LIST.HALF_GONE,
									GameConsts.UPGRADE_LIST.ALLERGY,
									GameConsts.UPGRADE_LIST.OVERFED
											]
var default_upgrade_card: int = GameConsts.UPGRADE_LIST.AREA_SIZE_1

@onready var upgrade_overview: AnimatedSprite2D = $UpgradeOverview

@onready var card_deal_audio: AudioStreamPlayer = $CardDealAudio
@onready var button_press_audio: AudioStreamPlayer = $ButtonPressAudio

func _ready() -> void:
	#if GameConsts.test_mode:
		#upgrade_card_pool= [
								#
								#GameConsts.UPGRADE_LIST.FRUIT_MAGNET_2,
								#GameConsts.UPGRADE_LIST.FRUIT_MAGNET_2,
								#GameConsts.UPGRADE_LIST.FRUIT_MAGNET_2,
								#GameConsts.UPGRADE_LIST.FRUIT_MAGNET_2,
		#]
									
	
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
	
	if RunSettings.current_char == GameConsts.CHAR_LIST.CHAMELEON:
		rainbow_slots = [$UpgradeOverview/UpgradeSlotRainbow]
		slots.append($UpgradeOverview/UpgradeSlotRainbow)
	else:
		$UpgradeOverview/UpgradeSlotRainbow.queue_free()
	
	$ItemShelf.hide()
	
	#mechanism to hide salamander upgrade added at start
	hide()
	await get_tree().create_timer(0.5).timeout
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).set_parallel(true)
	for slot in slots:
		tween.tween_property(slot, "scale", Vector2(0,0), 0.5)
	await tween.finished
	show()
	

func initiate_map_preview(maporder: Array):
	if maporder.size() != 3:
		print_debug("not 3 maps or 3 previews")
		return
	for index in range(len(maporder)):
		item_shelf.map_preview.set_map_preview(index, maporder[index])

func update_map_preview(current_act, current_round):
	item_shelf.map_preview.set_map_covering(current_act)
	item_shelf.map_preview.set_round_indicators(current_act, current_round)

func _on_got_clicked(upgrade_card: UpgradeCard):
	
	var upgrade_id = upgrade_card.upgrade_id
	var buy_price = upgrade_card.price
	var replace_price = max(0,buy_price - 1)
	
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
				chosen_slots = default_slots.duplicate()
			GameConsts.UPGRADE_TYPE.PASSIVE:
				chosen_slots = passive_slots.duplicate()
			GameConsts.UPGRADE_TYPE.BODYMOD:
				chosen_slots = bodymod_slots.duplicate()
			GameConsts.UPGRADE_TYPE.SYNERGY:
				chosen_slots = synergy_slots.duplicate()
			GameConsts.UPGRADE_TYPE.ACTIVE:
				chosen_slots = active_slots.duplicate()
			GameConsts.UPGRADE_TYPE.SPECIAL:
				chosen_slots = special_slots.duplicate()
		
		if RunSettings.current_char == GameConsts.CHAR_LIST.CHAMELEON and\
		GameConsts.get_upgrade_type(upgrade_id) != GameConsts.UPGRADE_TYPE.DEFAULT:
			chosen_slots.append(rainbow_slots[0])
		
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

func select_random_base_upgrade(type):
	upgrade_card_pool.shuffle()
	for upgrade in upgrade_card_pool:
		if GameConsts.get_upgrade_type(upgrade) == type and !GameConsts.advanced_upgrades.has(upgrade):
			return upgrade
	print_debug("no random Upgrade found")

func can_afford(slot):
	if slot.get_node("Area2D").get_child(-1) is UpgradeCard and\
	slot.get_node("Area2D").get_child(-1).card_sprite.frame == GameConsts.UPGRADE_LIST.DEAD_MOUSE:
		return false
	return 	int(slot.get_node("BuyZone").get_node("Price").text) <= fruits_currency

func _on_upgrade_card_bought(upgrade_id: int, slot) -> void:
	var upgrade_id_string = ""
	if upgrade_id < 10:
		upgrade_id_string += "0"
	upgrade_id_string += str(upgrade_id)
	RunHistoryCodeManager.buys[-1] += "b" + upgrade_id_string
	
	fruits_currency -= int(slot.get_node("BuyZone").get_node("Price").text)
	currency_number_label.text = str(fruits_currency)
	update_upgrade_pool(upgrade_id, true)
	#automatically deal new cards after map space was bought
	if upgrade_id == GameConsts.UPGRADE_LIST.AREA_SIZE_1 or\
	upgrade_id == GameConsts.UPGRADE_LIST.AREA_SIZE_2 or\
	upgrade_id == GameConsts.UPGRADE_LIST.AREA_SIZE_3:
		_on_skip_mapspace_pressed()
	#giving levelmanager the information on which slot the upgrade got bought
	if GameConsts.get_upgrade_type(upgrade_id) == GameConsts.UPGRADE_TYPE.ACTIVE:
		SignalBus.update_active_slot_infos.emit(upgrade_id, slot.name)
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
	upgrade_card._snap_to_slot(free_slot.get_node("Area2D").global_position)
	update_upgrade_pool(upgrade_id, true)
	SignalBus.upgrade_bought.emit(upgrade_id)
	
	

func is_filled(slot):
	return slot.get_node("Area2D").get_child(-1) is UpgradeCard

func update_upgrade_pool(upgrade_id: int, bought_not_destroyed: bool):
	if bought_not_destroyed:
		upgrade_card_pool.erase(upgrade_id)
		special_upgrade_card_pool.erase(upgrade_id)
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
	skip_mapspace.disabled = true
	deal_new_cards.disabled = true
	var shelf_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	shelf_tween.tween_property($ItemShelf, "rotation_degrees", -180, 0.8)
	await  shelf_tween.finished
	for upgrade_card in get_tree().get_nodes_in_group("UpgradeCard"):
		if not upgrade_card.is_bought:
			
			var upgrade_id_string = ""
			if upgrade_card.upgrade_id < 10:
				upgrade_id_string += "0"
			upgrade_id_string += str(upgrade_card.upgrade_id)
			RunHistoryCodeManager.buys[-1] += "s" + upgrade_id_string
			
			upgrade_card.queue_free()
	finished_buying.emit()
	
	RunHistoryCodeManager.buys.append("")

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
	map_space_deal = false

func generate_mapspace_item():
	for upgrade_card in get_node("ItemShelf").get_children():
		if upgrade_card is UpgradeCard:
			upgrade_card.queue_free()
	deal_upgrade_cards([default_upgrade_card])
	map_space_deal = true

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
		card_tween.tween_property(upgrade_card, "position" ,items_shop_slots[itemcounter].position + offset_vector, 0.2 + itemcounter * 0.1)
		card_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
		card_tween.tween_property(upgrade_card, "position", items_shop_slots[itemcounter].position, 0.4)
		upgrade_card.shelf_position = items_shop_slots[itemcounter].global_position  + Vector2(upgrade_card.size.x/2,upgrade_card.size.y/2)
		itemcounter += 1
	upgrade_cards_instantiated.emit()
	await card_tween.finished
	card_tween.stop()

func reset_reroll_cost():
	reroll_cost_number = reroll_cost_start_number

func reset_area_and_currency():
	reset_reroll_cost()
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
	deal_new_cards.position.y = 1928
	skip_mapspace.position.y = 1928
	if run_manager.current_round == 3 and run_manager.current_act == 2:
		RunHistoryCodeManager.generate_code()
		RunHistoryCodeManager.codestring += "Y"
		var datetime = Time.get_datetime_dict_from_system()
		RunHistoryCodeManager.codestring += str(datetime.day)
		RunHistoryCodeManager.codestring += str(datetime.hour)
		$EndScreen.show()
	$ItemShelf.rotation_degrees = -180
	var shelf_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	shelf_tween.tween_property($ItemShelf, "rotation_degrees", 0, 0.5)
	return shelf_tween

func hide_shop():
	toggle_upgrade_panel(true)
	$ItemShelf.hide()

func deal_new_cards_button_appear():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(deal_new_cards, "position:y", 1104, 0.4)
	await tween.finished
	deal_new_cards.disabled = false

func skip_mapspace_button_appear():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(skip_mapspace, "position:y", 1104, 0.4)
	await tween.finished
	skip_mapspace.disabled = false

func toggle_upgrade_panel(upgrades_expanded) -> void:
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).set_parallel(true)
	if not upgrades_expanded:
		upgrade_overview.play_backwards("disappear")
		for slot in slots:
			tween.tween_property(slot, "scale", Vector2(1,1), 0.5)
		upgrades_expanded = true
	else:
		upgrade_overview.play("disappear")
		for slot in slots:
			tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
			tween.tween_property(slot, "scale", Vector2(0,0), 0.5)
		upgrades_expanded = false


func _on_continue_next_round_mouse_entered() -> void:
	var upcoming_mapmod = run_manager.mapmodorder[run_manager.current_round+1]
	item_shelf.show_mapmod_description(upcoming_mapmod)


func _on_continue_next_round_mouse_exited() -> void:
	item_shelf.hide_mapmod_description()

var map_space_deal: bool = true
func _on_deal_new_cards_pressed() -> void:
	if GameConsts.test_mode:
		reroll_cost_number = 0
		reroll_cost_label.text = str(reroll_cost_number)
	
	if map_space_deal:
		for upgrade_card in get_node("ItemShelf").get_children():
			if upgrade_card is UpgradeCard:
				upgrade_card.queue_free()
		generate_items(run_manager.current_round)
	elif fruits_currency >= reroll_cost_number:
		fruits_currency -= reroll_cost_number
		currency_number_label.text = str(fruits_currency)
		reroll_cost_number += 1
		reroll_cost_label.text = str(reroll_cost_number)
		for upgrade_card in get_node("ItemShelf").get_children():
			if upgrade_card is UpgradeCard:
				var upgrade_id_string = ""
				if upgrade_card.upgrade_id < 10:
					upgrade_id_string += "0"
				upgrade_id_string += str(upgrade_card.upgrade_id)
				RunHistoryCodeManager.buys[-1] += "s" + upgrade_id_string
				upgrade_card.queue_free()
		generate_items(run_manager.current_round)
	else:
		print_debug("not enough money to reroll")


func _on_skip_mapspace_pressed() -> void:
	skip_mapspace.disabled = true
	deal_new_cards.disabled = true
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(skip_mapspace, "position:y", 1928, 0.4)
	await tween.finished
	_on_deal_new_cards_pressed()
	deal_new_cards_button_appear()
