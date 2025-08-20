extends TileMapLayer

signal next_tile_reached
var snake_anim_plays: bool = false
var decreasing_menu_snake_speed: float

@onready var tail_follow: PathFollow2D = $Path2D/TailFollow
@onready var head_follow: PathFollow2D = $Path2D/HeadFollow
@export var has_front_legs: bool
@export var has_back_legs: bool
var bodyparts: Array

func _ready() -> void:
	decreasing_menu_snake_speed = get_parent().menu_snake_speed
	
	for child in get_children():
		if child.get_groups().has("Snake"):
			bodyparts.append(child)

func play_snake_anim():
	snake_anim_plays = true
	for i in bodyparts.size()+1:
		if i < bodyparts.size():
			bodyparts[i].hide()
			show_bodypart_later(bodyparts[i], decreasing_menu_snake_speed * 2)
		next_tile_reached.emit()
		var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT).set_parallel()
		tween.tween_property(tail_follow, "progress", tail_follow.progress+80,decreasing_menu_snake_speed)
		tween.tween_property(head_follow, "progress", head_follow.progress+80,decreasing_menu_snake_speed)
		if has_front_legs:
			tween.tween_method(_set_animation_progress, 0.0, head_follow.get_node("LegAnimationPlayer").current_animation_length, decreasing_menu_snake_speed).set_trans(Tween.TRANS_LINEAR)
		if has_back_legs:
			tween.tween_method(_set_animation_progress, 0.0, tail_follow.get_node("LegAnimationPlayer").current_animation_length, decreasing_menu_snake_speed).set_trans(Tween.TRANS_LINEAR)
		decreasing_menu_snake_speed += 0.014
		await tween.finished
	decreasing_menu_snake_speed = get_parent().menu_snake_speed
	snake_anim_plays = false

func show_bodypart_later(part: Node, delay_time: float) -> void:
	await get_tree().create_timer(delay_time).timeout
	part.show()

func _set_animation_progress(time: float):
	if has_front_legs:
		head_follow.get_node("LegAnimationPlayer").seek(time, true)
	if has_back_legs:
		tail_follow.get_node("LegAnimationPlayer").seek(time, true)
