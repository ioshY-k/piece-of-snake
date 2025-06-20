class_name UpgradeCard extends Control

var mouse_in: bool = false
var is_dragging: bool = false
@onready var card_shadow: Sprite2D = $CardSprite/CardShadow
@onready var card_sprite: AnimatedSprite2D = $CardSprite
@onready var card_area: Area2D = $CardArea

@export var upgrade_id: int

var owned_slot: Area2D = null

var is_bought: bool = false
signal bought

func _ready() -> void:
	bought.connect(get_parent()._on_upgrade_card_bought)

func instantiate_upgrade_card(id: int):
	upgrade_id = id
	card_sprite.frame = id

	
	

func _process(delta: float) -> void:
	drag_logic(delta)

func drag_logic(delta: float):
	card_shadow.position = Vector2(.12, 12).rotated(card_sprite.rotation)
	if (mouse_in or is_dragging) and (GameConsts.node_being_dragged == null or GameConsts.node_being_dragged == self):
		if Input.is_action_pressed("click"):
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
				if !is_bought and !card_area.get_overlapping_areas().is_empty():
					owned_slot = card_area.get_overlapping_areas()[0]
					card_sprite.rotation_degrees = 0
					_snap_to_slot(card_area.get_overlapping_areas()[0])
					card_area.get_overlapping_areas()[0].set_collision_layer_value(4, false)
					is_bought = true
					bought.emit(upgrade_id)
				if is_bought:
					_snap_to_slot(owned_slot)
			is_dragging = false
			if GameConsts.node_being_dragged == self:
				GameConsts.node_being_dragged = null
		return
	
	card_sprite.z_index = 10
	_change_scale(Vector2(1.2,1.2))

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
