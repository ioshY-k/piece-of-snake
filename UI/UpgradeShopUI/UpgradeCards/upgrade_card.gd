class_name UpgradeCard extends Control

var mouse_in: bool = false
var is_dragging: bool = false
@onready var card_shadow: Sprite2D = $CardSprite/CardShadow
@onready var card_sprite: AnimatedSprite2D = $CardSprite
@onready var card_area: Area2D = $CardArea

@export var upgrade_id: int
var upgrade_type: int
var is_advanced: bool
var has_advancements: bool

var owned_slot: Area2D = null


var is_bought: bool = false
signal bought
signal destroyed

signal got_clicked
signal let_go

func _ready() -> void:
	got_clicked.connect(get_parent().get_parent()._on_got_clicked)
	bought.connect(get_parent().get_parent()._on_upgrade_card_bought)
	destroyed.connect(get_parent().get_parent()._on_upgrade_destroyed)
	let_go.connect(get_parent().get_parent()._on_let_go)

func instantiate_upgrade_card(id: int):
	upgrade_id = id
	card_sprite.frame = id
	
	is_advanced = GameConsts.advanced_upgrades.has(upgrade_id)
	has_advancements = GameConsts.upgrades_with_advancement.has(upgrade_id)
	upgrade_type = GameConsts.get_upgrade_type(id)

	

func _process(delta: float) -> void:
	drag_logic(delta)

func drag_logic(delta: float):
	card_shadow.position = Vector2(.12, 12).rotated(card_sprite.rotation)
	if (mouse_in or is_dragging) and (GameConsts.node_being_dragged == null or GameConsts.node_being_dragged == self):
		if Input.is_action_pressed("click"):
			if Input.is_action_just_pressed("click"):
				got_clicked.emit(upgrade_id)
			global_position = lerp(global_position, get_global_mouse_position() - (size/2.0), 22*delta)
			_change_scale(Vector2(1.26,1.26))
			_set_rotation(delta)
			card_sprite.z_index = 100
			is_dragging = true
			GameConsts.node_being_dragged = self
		else:
			_change_scale(Vector2(1.42,1.42))
			card_sprite.rotation_degrees = lerp(card_sprite.rotation_degrees, 0.0, 22*delta)
			if is_dragging:
				let_go.emit()
				decide_on_let_go()
			is_dragging = false
			if GameConsts.node_being_dragged == self:
				GameConsts.node_being_dragged = null
		return
	
	card_sprite.z_index = 5
	_change_scale(Vector2(1.2,1.2))

func decide_on_let_go():
	if is_bought:
		_snap_to_slot(owned_slot)
		return
	if card_area.get_overlapping_areas().is_empty():
		return
	
	owned_slot = card_area.get_overlapping_areas()[0]
	
	
	
	var replaced_card: UpgradeCard
	if owned_slot.get_child(-1) is UpgradeCard:
		replaced_card = owned_slot.get_child(-1)
	

	#the upgrade type must be the same as the upgrade type for the slot
	#also: if it is an advanced upgrade, the replaced upgrade has to be the prior version of it
	if upgrade_type == get_slot_type(owned_slot.get_parent().get_groups()[0]) and\
	(!is_advanced or (replaced_card != null and replaced_card.upgrade_id == upgrade_id - 1)):
		
		card_sprite.rotation_degrees = 0
		_snap_to_slot(owned_slot)
		
		if replaced_card != null:
			replaced_card.destroyed.emit(replaced_card.upgrade_id)
			replaced_card.queue_free()
		
		get_parent().remove_child(self)
		owned_slot.add_child(self)
		
		is_bought = true
		bought.emit(upgrade_id)

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
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "global_position", upgrade_slot.global_position - (size/2), 0.2)

func _on_mouse_entered() -> void:
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
