class_name Tongue extends Node2D

var map: Map
var tongue_speed = 1900
var rolling_in:bool = false
@onready var tongue_sprite: AnimatedSprite2D = $TongueMask/TongueSprite
@onready var tongue_area: Area2D = $TongueMask/TongueSprite/TongueArea

func _ready() -> void:
	map = get_parent().get_parent()
	await get_tree().create_timer(0.1).timeout
	tongue_area.set_collision_mask_value(6,true)

func _process(delta: float) -> void:
	if rolling_in:
		tongue_roll_in(delta)
	else:
		tongue_roll_out(delta)
		
	if tongue_sprite.position.x > 0:
		rolling_in = true
	if tongue_area.has_overlapping_areas():
		for obstacle in tongue_area.get_overlapping_areas():
			if obstacle.get_collision_layer_value(1) or obstacle.get_collision_layer_value(6):#solid or obstacle
				rolling_in = true
				break
			elif obstacle.get_collision_layer_value(2) and not obstacle.collected and not rolling_in:#uncollected fruit
				obstacle.set_collision_layer_value(2,false)
				var tween = get_tree().create_tween()
				tween.tween_property(obstacle, "global_position", get_parent().global_position, 0.05)
				tween.tween_callback(Callable(obstacle, "set_collision_layer_value").bind(2,true))
				rolling_in = true
				break

func tongue_roll_out(delta):
	tongue_sprite.position.x += tongue_speed*delta

func tongue_roll_in(delta):
	tongue_sprite.position.x -= 1.5*tongue_speed*delta
