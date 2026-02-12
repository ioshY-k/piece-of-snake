class_name UpgradeCard extends Control

var font_colors = {
	str(GameConsts.UPGRADE_TYPE.DEFAULT) : Color(0.59, 0.59, 0.59),
	str(GameConsts.UPGRADE_TYPE.PASSIVE) : Color(0.88, 0.662, 0.484),
	str(GameConsts.UPGRADE_TYPE.BODYMOD) : Color(0.435, 0.82, 0.454),
	str(GameConsts.UPGRADE_TYPE.SYNERGY) : Color(0.333, 0.72, 0.9),
	str(GameConsts.UPGRADE_TYPE.ACTIVE) : Color(0.81, 0.405, 0.412),
	str(GameConsts.UPGRADE_TYPE.SPECIAL) : Color(0.707, 0.538, 0.96)
}

var mouse_in: bool = false
var is_dragging: bool = false
@onready var card_shadow: Sprite2D = $CardSprite/CardShadow
@onready var card_sprite: AnimatedSprite2D = $CardSprite
@onready var card_area: Area2D = $CardArea
@onready var sale_number: Label = $CardSprite/SaleTag/SaleNumber
@export var upgrade_id: int
@onready var upgrade_id_string: String
@onready var card_snap_audio: AudioStreamPlayer = $CardSnapAudio
@onready var card_select_audio: AudioStreamPlayer = $CardSelectAudio
@onready var card_deselect_audio: AudioStreamPlayer = $CardDeselectAudio
@onready var card_buy_audio: AudioStreamPlayer = $CardBuyAudio

@export var is_play_button = false

var upgrade_description: String
var upgrade_name: String
var font_color: Color
var keyword_descriptions: Array[String]
var upgrade_type: int
var is_advanced: bool
var has_advancements: bool

var owned_slot_area: Area2D = null
var shelf_position: Vector2

var base_price: int = 4
var price: int
var is_bought: bool = false
signal bought
signal destroyed

signal got_clicked
signal let_go
signal hovered

var shop: Shop
var item_shelf
	
func _ready() -> void:
	if is_play_button:
		let_go.connect(play_hovered_mode)
		shelf_position = Vector2(1249,529) + Vector2(size.x/2,size.y/2)
		return
	#globally accessed since salamander start Item is not added to Itemshelf as parent
	shop = get_node("/root/MainSceneLoader/RunManager/Shop")
	item_shelf = get_node("/root/MainSceneLoader/RunManager/Shop/ItemShelf")
	#setting the position to something on initialization for safety
	shelf_position = item_shelf.find_child("Itemslot1").global_position + Vector2(size.x/2,size.y/2)
	got_clicked.connect(shop._on_got_clicked)
	bought.connect(shop._on_upgrade_card_bought)
	destroyed.connect(shop._on_upgrade_destroyed)
	let_go.connect(shop._on_let_go)
	hovered.connect(item_shelf.change_item_description)

func turn_into_playbutton():
	card_sprite.play("play_button_anim")

func play_hovered_mode():
	if card_area.get_overlapping_areas().is_empty():
		return
	
	var play_area: Area2D = card_area.get_overlapping_areas()[0]
	match play_area.name:
		"EasyArea":
			get_parent()._on_easy_run_pressed()
		"NormalArea":
			get_parent()._on_normal_run_pressed()
		"HardArea":
			get_parent()._on_hard_run_pressed()
	

func instantiate_upgrade_card(id: int):
	upgrade_id_string = TextConsts.get_id_string(GameConsts.UPGRADE_LIST, id)
	
	upgrade_name = TextConsts.get_text(TextConsts.TABLES.CARDS,upgrade_id_string, "NAME")
	upgrade_description = TextConsts.get_text(TextConsts.TABLES.CARDS,upgrade_id_string, "DESC").format({
		"GHOST_FRUIT_KEYWORD": TextConsts.get_text(TextConsts.TABLES.KEYWORDS,"GHOST_FRUIT_KEYWORD","NAME"),
		"TASTY_KEYWORD": TextConsts.get_text(TextConsts.TABLES.KEYWORDS,"TASTY_KEYWORD","NAME"),
		"ADVANCEMENT_KEYWORD": TextConsts.get_text(TextConsts.TABLES.KEYWORDS,"ADVANCEMENT_KEYWORD","NAME"),
		"HOLLOW_KEYWORD": TextConsts.get_text(TextConsts.TABLES.KEYWORDS,"HOLLOW_KEYWORD","NAME"),
		"DENSE_KEYWORD": TextConsts.get_text(TextConsts.TABLES.KEYWORDS,"DENSE_KEYWORD","NAME"),
		"PHASING_KEYWORD": TextConsts.get_text(TextConsts.TABLES.KEYWORDS,"PHASING_KEYWORD","NAME"),
		"SHIELDED_KEYWORD": TextConsts.get_text(TextConsts.TABLES.KEYWORDS,"SHIELDED_KEYWORD","NAME"),
		"ACTION_KEYWORD": TextConsts.get_text(TextConsts.TABLES.KEYWORDS,"ACTION_KEYWORD","NAME"),
		"REACTION_KEYWORD": TextConsts.get_text(TextConsts.TABLES.KEYWORDS,"REACTION_KEYWORD","NAME"),
	})
	if TextConsts.get_text(TextConsts.TABLES.CARDS,upgrade_id_string, "DESC").contains("{ADVANCEMENT_KEYWORD}"):
		keyword_descriptions.append(TextConsts.get_text(TextConsts.TABLES.KEYWORDS, "ADVANCEMENT_KEYWORD", "NAME")
		+ " " + TextConsts.get_text(TextConsts.TABLES.KEYWORDS, "ADVANCEMENT_KEYWORD", "DESC"))
	if TextConsts.get_text(TextConsts.TABLES.CARDS,upgrade_id_string, "DESC").contains("{GHOST_FRUIT_KEYWORD}"):
		keyword_descriptions.append(TextConsts.get_text(TextConsts.TABLES.KEYWORDS, "GHOST_FRUIT_KEYWORD", "NAME")
		+ " " + TextConsts.get_text(TextConsts.TABLES.KEYWORDS, "GHOST_FRUIT_KEYWORD", "DESC"))
	if TextConsts.get_text(TextConsts.TABLES.CARDS,upgrade_id_string, "DESC").contains("{TASTY_KEYWORD}"):
		keyword_descriptions.append(TextConsts.get_text(TextConsts.TABLES.KEYWORDS, "TASTY_KEYWORD", "NAME")
		+ " " + TextConsts.get_text(TextConsts.TABLES.KEYWORDS, "TASTY_KEYWORD", "DESC"))
	if TextConsts.get_text(TextConsts.TABLES.CARDS,upgrade_id_string, "DESC").contains("{PHASING_KEYWORD}"):
		keyword_descriptions.append(TextConsts.get_text(TextConsts.TABLES.KEYWORDS, "PHASING_KEYWORD", "NAME")
		+ " " + TextConsts.get_text(TextConsts.TABLES.KEYWORDS, "PHASING_KEYWORD", "DESC"))
	if TextConsts.get_text(TextConsts.TABLES.CARDS,upgrade_id_string, "DESC").contains("{HOLLOW_KEYWORD}"):
		keyword_descriptions.append(TextConsts.get_text(TextConsts.TABLES.KEYWORDS, "HOLLOW_KEYWORD", "NAME")
		+ " " + TextConsts.get_text(TextConsts.TABLES.KEYWORDS, "HOLLOW_KEYWORD", "DESC"))
	if TextConsts.get_text(TextConsts.TABLES.CARDS,upgrade_id_string, "DESC").contains("{DENSE_KEYWORD}"):
		keyword_descriptions.append(TextConsts.get_text(TextConsts.TABLES.KEYWORDS, "DENSE_KEYWORD", "NAME")
		+ " " + TextConsts.get_text(TextConsts.TABLES.KEYWORDS, "DENSE_KEYWORD", "DESC"))
	if TextConsts.get_text(TextConsts.TABLES.CARDS,upgrade_id_string, "DESC").contains("{SHIELDED_KEYWORD}"):
		keyword_descriptions.append(TextConsts.get_text(TextConsts.TABLES.KEYWORDS, "SHIELDED_KEYWORD", "NAME")
		+ " " + TextConsts.get_text(TextConsts.TABLES.KEYWORDS, "SHIELDED_KEYWORD", "DESC"))
	
	upgrade_id = id
	card_sprite.frame = id
	
	#unused
	font_color = font_colors[str(GameConsts.get_upgrade_type(id))]
	is_advanced = GameConsts.advanced_upgrades.has(upgrade_id)
	has_advancements = GameConsts.upgrades_with_advancement.has(upgrade_id)
	upgrade_type = GameConsts.get_upgrade_type(id)
	price = calculate_price()
	SignalBus.price_calculated.emit(self)


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
			if Input.is_action_just_pressed("click"):
				card_select_audio.play()
				if not is_bought:
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
				card_deselect_audio.play()
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
		_snap_to_slot(owned_slot_area.global_position)
		card_snap_audio.play()
		return
	if card_area.get_overlapping_areas().is_empty():
		_snap_to_slot(shelf_position)
		return
	owned_slot_area = card_area.get_overlapping_areas()[0]
	
	var replaced_card: UpgradeCard
	if owned_slot_area.get_child(-1) is UpgradeCard:
		replaced_card = owned_slot_area.get_child(-1)

	#the upgrade type must be the same as the upgrade type for the slot
	#also: if it is an advanced upgrade, the replaced upgrade has to be the prior version of it
	if upgrade_type == get_slot_type(owned_slot_area.get_parent().get_groups()[0]) and\
	(!is_advanced or (replaced_card != null and replaced_card.upgrade_id == upgrade_id - 1)):
		
		if shop.can_afford(owned_slot_area.get_parent()):
			card_sprite.rotation_degrees = 0
			_snap_to_slot(owned_slot_area.global_position)
			card_buy_audio.play()
			if replaced_card != null:
				replaced_card.destroyed.emit(replaced_card.upgrade_id)
				replaced_card.queue_free()
			
			get_parent().remove_child(self)
			owned_slot_area.add_child(self)
			
			await get_tree().process_frame
			is_bought = true
			sale_number.get_parent().hide()
			bought.emit(upgrade_id, owned_slot_area.get_parent())
		else:
			_snap_to_slot(shelf_position)
	elif not is_play_button:
		_snap_to_slot(shelf_position)
		return

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


func _snap_to_slot(slot_pos: Vector2):
	var start_position = global_position
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "global_position", slot_pos - (size/2), 0.3).from(start_position)

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
			print_debug("No Slot Type is matching with card type (maybe it is the play button?)")
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
