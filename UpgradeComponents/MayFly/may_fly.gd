class_name MayFly extends Node2D

const FLY_SPEED = 100
var map: Map
var component
var top_left_bound: Vector2i
var bottom_right_bound: Vector2i
@onready var area_2d: Area2D = $AnimatedSprite2D/Area2D
@onready var may_fly_animation_player: AnimationPlayer = $MayFlyAnimationPlayer

var diagonals: Array[Vector2i] = [Vector2i(1,1),Vector2i(-1,1),Vector2i(1,-1),Vector2i(-1,-1)]
var current_diagonal = diagonals[randi()%diagonals.size()]

func _ready() -> void:
	map = get_parent()
	top_left_bound = MapData.call_map_data_at_zoom(map.zoom_state, map.get_parent().current_map_index)[3]
	bottom_right_bound = MapData.call_map_data_at_zoom(map.zoom_state, map.get_parent().current_map_index)[4]
	SignalBus.round_over.connect(func(): queue_free())

func _process(delta: float) -> void:
	position += current_diagonal*FLY_SPEED*delta
	if position.x > TileHelper.tile_to_position(bottom_right_bound).x:
		current_diagonal.x = -1
	if position.x < TileHelper.tile_to_position(top_left_bound).x:
		current_diagonal.x = 1
	if position.y > TileHelper.tile_to_position(bottom_right_bound).y:
		current_diagonal.y = -1
	if position.y < TileHelper.tile_to_position(top_left_bound).y:
		current_diagonal.y = 1
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	area_2d.set_collision_mask_value(14,false)
	may_fly_animation_player.play("collected_anim")
	component.caught.emit()
	await may_fly_animation_player.animation_finished
	queue_free()
