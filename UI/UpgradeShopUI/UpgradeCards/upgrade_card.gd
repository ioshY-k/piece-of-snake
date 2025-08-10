class_name UpgradeCard extends Control

var upgrade_descriptions = {
	str(GameConsts.UPGRADE_LIST.AREA_SIZE_1) : "Uncover [color=9e9e9e]more area.[/color]\n\nThis Upgrade is lost upon reaching the next act.",
	str(GameConsts.UPGRADE_LIST.AREA_SIZE_2) : "Uncover [color=9e9e9e]even more area.[/color]\n\nThis Upgrade is lost upon reaching the next act.",
	str(GameConsts.UPGRADE_LIST.AREA_SIZE_3) : "Uncover the [color=9e9e9e]maximum amount of area.[/color]\n\nThis Upgrade is lost upon reaching the next act.",
	str(GameConsts.UPGRADE_LIST.FRUIT_MAGNET_1) : "[color=ffc875]Attract fruit[/color] in front of you.",
	str(GameConsts.UPGRADE_LIST.FRUIT_MAGNET_2) : "Attract fruit in a [color=ffc875]radius around you[/color].",
	str(GameConsts.UPGRADE_LIST.FRUIT_MAGNET_3) : "Attract fruit in a [color=ffc875]larger radius[/color].",
	str(GameConsts.UPGRADE_LIST.HYPER_SPEED_1) : "Gain a [color=ffc875]larger Hyper Speed Meter[/color].",
	str(GameConsts.UPGRADE_LIST.HYPER_SPEED_2) : "The Hyper Speed Meter [color=ffc875]refills faster[/color].",
	str(GameConsts.UPGRADE_LIST.HYPER_SPEED_3) : "Gain [color=ffc875]unlimited Hyper Speed[/color].",
	str(GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_1) : "[color=ffc875]Two Fruits[/color] at once will appear on the Map.",
	str(GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_2) : "The longer a Fruit is [color=ffc875]left uncollected[/color], the more Fruits it will grant on collection.",
	str(GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_3) : "[color=ffc875]Three Fruits[/color] at once will appear on the Map.",
	str(GameConsts.UPGRADE_LIST.EDGE_WRAP_1) : "When exiting the screen, [color=ffc875]enter on the opposite side[/color].",
	str(GameConsts.UPGRADE_LIST.EDGE_WRAP_2) : "NO DESCRIPTION YET",
	str(GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_1) : "All fruits [color=#ff9191]change their position[/color].\n\nUsable up to 2 times.",
	str(GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_2) : "All fruits [color=#ff9191]change their position[/color].\n\nUsable up to 3 times.",
	str(GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_3) : "All fruits [color=#ff9191]change their position[/color].\n\nUsable up to 5 times.",
	str(GameConsts.UPGRADE_LIST.CROSS_ROAD_1) : "Place a [color=#ff9191]permanent Crossroad[/color] on the Map.\n\nBodyparts may [color=#ff9191]overlap[/color] on it 1 time.\n\nUsable up to 1 time.",
	str(GameConsts.UPGRADE_LIST.CROSS_ROAD_2) : "NO DESCRIPTION YET",
	str(GameConsts.UPGRADE_LIST.CROSS_ROAD_3) : "NO DESCRIPTION YET",
	str(GameConsts.UPGRADE_LIST.TAIL_CUT) : "One time per round, [color=#80d984]cut off your tail[/color] when surpassing it",
	str(GameConsts.UPGRADE_LIST.CORNER_PHASING) : "Corners you take [color=#80d984]may be overlapped[/color] 1 time",
	str(GameConsts.UPGRADE_LIST.KNOT_SLOWMO) : "The [color=#4fabf9]timer stops[/color] whenever you surpass your body",
	str(GameConsts.UPGRADE_LIST.ITEM_RELOADER) : "When reaching the fruit threshold, [color=#4fabf9]all Active Items get refilled[/color]",
	str(GameConsts.UPGRADE_LIST.IMMUTABLE) : "NO DESCRIPTION YET",
	str(GameConsts.UPGRADE_LIST.MOULTING) : "[color=#d75eff]Remove every Body Modification[/color]. You can buy [color=#d75eff]one more Item[/color] in Shops",
	str(GameConsts.UPGRADE_LIST.ANCHOR) : "[color=#d75eff]No longer auto move forward[/color] and become invincible while standing still.\n\n[color=#d75eff]Loose double the fruits[/color] when hitting an obstacle",
	str(GameConsts.UPGRADE_LIST.TIME_STOP_1) : "[color=#ff9191]Stop moving[/color] for as long as the button is held down.\n\nBecome invincible while standing still.\n\nUsable up to 3 times.",
	str(GameConsts.UPGRADE_LIST.TIME_STOP_2) : "NO DESCRIPTION YET",
	str(GameConsts.UPGRADE_LIST.TIME_STOP_3) : "NO DESCRIPTION YET",
	str(GameConsts.UPGRADE_LIST.WORMHOLE_1) : "[color=#ff9191]Create a Portal[/color] in front of you and [color=#ff9191]choose its destination tile[/color].\n\nThe Portal disappears after it is used.\n\nUsable up to 2 times.",
	str(GameConsts.UPGRADE_LIST.WORMHOLE_2) : "[color=#ff9191]Create a Portal[/color] in front of you and [color=#ff9191]choose its destination tile[/color].\n\nThe Portal disappears after it is used.\n\nUsable up to 4 times.",
	str(GameConsts.UPGRADE_LIST.WORMHOLE_3) : "[color=#ff9191]Create a Portal[/color] in front of you and [color=#ff9191]choose its destination tile[/color].\n\nThe Portal disappears after it is used.\n\nUsable up to 6 times.",
	str(GameConsts.UPGRADE_LIST.PIGGY_BANK) : "When destroying this Item,\n[color=#4fabf9]lower the Fruit threshold[/color] of the next round by 5",
	str(GameConsts.UPGRADE_LIST.SALE) : "For each filled Item category \n[color=#4fabf9]Reduce the cost[/color] of a random Item by 1",
	str(GameConsts.UPGRADE_LIST.DIET_1) : "Collecting fruits in quick succession makes [color=ffc875]growing less likeley[/color].",
	str(GameConsts.UPGRADE_LIST.DIET_2) : "[color=ffc875]Don't grow at all[/color] when collecting overstock fruit.",
	str(GameConsts.UPGRADE_LIST.DIET_3) : "The probability for not growing [color=ffc875]stays high for longer[/color].",
	str(GameConsts.UPGRADE_LIST.COATING) : "[color=#80d984]Prevent[/color] the first time [color=#80d984]losing fruit[/color] per round",
	str(GameConsts.UPGRADE_LIST.STEEL_HELMET) : "[color=#80d984]Don't get hit[/color] when running into walls [color=#80d984]with Hyper Speed[/color].\nYour body doesn't count.",
	str(GameConsts.UPGRADE_LIST.FUEL_1) : "Collecting fruits while in Hyper Speed [color=ffc875]fills a chunk of the Hyper Speed gauge[/color].",
	str(GameConsts.UPGRADE_LIST.FUEL_2) : "Collecting fruits while in Hyper Speed [color=ffc875]fills a bigger chunk of the Hyper Speed gauge[/color].",
	str(GameConsts.UPGRADE_LIST.FUEL_3) : "Collecting fruits while in Hyper Speed [color=ffc875]refills the Hyper Speed gauge completely[/color]."
	}

var mouse_in: bool = false
var is_dragging: bool = false
@onready var card_shadow: Sprite2D = $CardSprite/CardShadow
@onready var card_sprite: AnimatedSprite2D = $CardSprite
@onready var card_area: Area2D = $CardArea
@onready var sale_number: Label = $CardSprite/SaleTag/SaleNumber
@export var upgrade_id: int
var upgrade_description: String
var upgrade_type: int
var is_advanced: bool
var has_advancements: bool

var owned_slot_area: Area2D = null

var base_price: int = 4
var price: int
var is_bought: bool = false
signal bought
signal destroyed

signal got_clicked
signal let_go
signal hovered

func _ready() -> void:
	got_clicked.connect(get_parent().get_parent()._on_got_clicked)
	bought.connect(get_parent().get_parent()._on_upgrade_card_bought)
	destroyed.connect(get_parent().get_parent()._on_upgrade_destroyed)
	let_go.connect(get_parent().get_parent()._on_let_go)
	hovered.connect(get_parent().change_item_description)

func instantiate_upgrade_card(id: int):
	upgrade_id = id
	card_sprite.frame = id
	upgrade_description = upgrade_descriptions[str(id)]
	is_advanced = GameConsts.advanced_upgrades.has(upgrade_id)
	has_advancements = GameConsts.upgrades_with_advancement.has(upgrade_id)
	upgrade_type = GameConsts.get_upgrade_type(id)
	price = calculate_price()

	

func _process(delta: float) -> void:
	drag_logic(delta)

func drag_logic(delta: float):
	#shadow always follows card
	card_shadow.position = Vector2(.12, 12).rotated(card_sprite.rotation)
	
	#all interacting logic works only on a single card, and only if mouse hovers or drags it
	if (mouse_in or is_dragging) and (GameConsts.node_being_dragged == null or GameConsts.node_being_dragged == self):
		#card is being dragged
		if Input.is_action_pressed("click"):
			#card is just now being dragged
			if Input.is_action_just_pressed("click") and not is_bought:
				got_clicked.emit(self)
			global_position = lerp(global_position, get_global_mouse_position() - (size/2.0), 22*delta)
			_change_scale(Vector2(0.7,0.7))
			_set_rotation(delta)
			card_sprite.z_index = 100
			is_dragging = true
			GameConsts.node_being_dragged = self
		#card is only being hovered
		else:
			_change_scale(Vector2(1.42,1.42))
			card_sprite.rotation_degrees = lerp(card_sprite.rotation_degrees, 0.0, 22*delta)
			#card is just now let go of
			if is_dragging:
				decide_on_let_go()
				let_go.emit()
			is_dragging = false
			if GameConsts.node_being_dragged == self:
				GameConsts.node_being_dragged = null
		return
	#card is not interacted with
	card_sprite.z_index = 5
	if is_bought:
		_change_scale(Vector2(0.7,0.7))
	else:
		_change_scale(Vector2(1,1))

func decide_on_let_go():
	if is_bought:
		_snap_to_slot(owned_slot_area)
		return
	if card_area.get_overlapping_areas().is_empty():
		return
	owned_slot_area = card_area.get_overlapping_areas()[0]
	
	var replaced_card: UpgradeCard
	if owned_slot_area.get_child(-1) is UpgradeCard:
		replaced_card = owned_slot_area.get_child(-1)
	

	#the upgrade type must be the same as the upgrade type for the slot
	#also: if it is an advanced upgrade, the replaced upgrade has to be the prior version of it
	if upgrade_type == get_slot_type(owned_slot_area.get_parent().get_groups()[0]) and\
	(!is_advanced or (replaced_card != null and replaced_card.upgrade_id == upgrade_id - 1)):
		
		if get_parent().get_parent().can_afford(owned_slot_area.get_parent()):
			card_sprite.rotation_degrees = 0
			_snap_to_slot(owned_slot_area)
			
			if replaced_card != null:
				replaced_card.destroyed.emit(replaced_card.upgrade_id)
				replaced_card.queue_free()
			
			get_parent().remove_child(self)
			owned_slot_area.add_child(self)
			
			await get_tree().process_frame
			is_bought = true
			sale_number.get_parent().hide()
			bought.emit(upgrade_id, owned_slot_area.get_parent())

var current_goal_scale: Vector2 = Vector2(1.2,1.2)
var scale_tween: Tween
func _change_scale(desired_scale: Vector2):
	if desired_scale == current_goal_scale:
		return
	
	if scale_tween:
		scale_tween.kill()
	scale_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	scale_tween.tween_property(card_sprite, "scale", desired_scale, 0.12)
	
	current_goal_scale = desired_scale


var last_pos: Vector2
var max_card_rotation: float = 12.5
func _set_rotation(delta: float) -> void:
	var desired_rotation: float = clamp((global_position-last_pos).x*0.85, -max_card_rotation, max_card_rotation)
	card_sprite.rotation_degrees = lerp(card_sprite.rotation_degrees, desired_rotation, 12*delta)
	last_pos = global_position


func _snap_to_slot(upgrade_slot: Area2D):
	var start_position = global_position
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "global_position", upgrade_slot.global_position - (size/2), 0.3).from(start_position)

func _on_mouse_entered() -> void:
	if not is_dragging:
		hovered.emit(self)
	mouse_in = true
	
func _on_mouse_exited() -> void:
	mouse_in = false

func get_slot_type(group) -> int:
	match group:
		"Slot Default":
			return GameConsts.UPGRADE_TYPE.DEFAULT
		"Slot Passive":
			return GameConsts.UPGRADE_TYPE.PASSIVE
		"Slot Synergy":
			return GameConsts.UPGRADE_TYPE.SYNERGY
		"Slot Bodymod":
			return GameConsts.UPGRADE_TYPE.BODYMOD
		"Slot Active":
			return GameConsts.UPGRADE_TYPE.ACTIVE
		"Slot Special":
			return GameConsts.UPGRADE_TYPE.SPECIAL
		_:
			print_debug("No Slot Type is matching with card type")
			return -1

func calculate_price():
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
	
	return base_price + modifier
