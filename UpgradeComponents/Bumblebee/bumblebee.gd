class_name Bumblebee extends Node2D

const FLY_SPEED = 270
var map: Map
var component
var top_left_bound: Vector2i
var bottom_right_bound: Vector2i
var fly_speed = 200
var is_turning: bool = false
@onready var area_2d: Area2D = $Path2D/PathFollow2D/AnimatedSprite2D/Area2D
@onready var bumblebee_animation_player: AnimationPlayer = $AnimationPlayer
@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D

var diagonals: Array[Vector2i] = [Vector2i(1,1),Vector2i(-1,1),Vector2i(1,-1),Vector2i(-1,-1)]
var current_diagonal = diagonals[randi()%diagonals.size()]

func _ready() -> void:
	map = get_parent()
	top_left_bound = MapData.call_map_data_at_zoom(map.zoom_state, map.get_parent().current_map_index)[3]
	bottom_right_bound = MapData.call_map_data_at_zoom(map.zoom_state, map.get_parent().current_map_index)[4]
	var horizontal_center = (top_left_bound.x + bottom_right_bound.x) / 2
	var vertical_center = (top_left_bound.y + bottom_right_bound.y) / 2
	position = TileHelper.tile_to_position(Vector2i(horizontal_center,vertical_center))
	path_follow_2d.progress_ratio = randf()
	SignalBus.round_over.connect(
		func(): queue_free())
	
func _process(delta: float) -> void:
	var distance = (map.snake_head.global_position - area_2d.global_position).length()
	if distance < 200 and not is_turning:
		turn()
	path_follow_2d.progress += fly_speed*delta

func turn():
	is_turning = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "fly_speed", -fly_speed, 0.24)
	await tween.finished
	await get_tree().create_timer(3).timeout
	is_turning = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	area_2d.set_collision_mask_value(14,false)
	component.caught.emit()
	SignalBus.insect_caught.emit()
	bumblebee_animation_player.play("collected_anim")
	await bumblebee_animation_player.animation_finished
	queue_free()
