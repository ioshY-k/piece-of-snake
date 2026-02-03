class_name DragonFly extends Node2D

var map: Map
var catches_left: int

@onready var dragon_fly_area: Area2D = $AnimatedSprite2D/DragonFlyArea
@onready var fly_away_timer: Timer = $FlyAwayTimer
@onready var cpu_particles_2d: CPUParticles2D = $AnimatedSprite2D/CPUParticles2D
@onready var dragon_fly_animation_player: AnimationPlayer = $DragonFlyAnimationPlayer

func _ready() -> void:
	map = get_parent()
	fly_away_timer.timeout.connect(fly_away)

func decrement_catches():
	catches_left -= 1
	change_appereance()


func fly_away():
	fly_away_timer.start(fly_away_timer.wait_time)
	dragon_fly_area.set_collision_mask_value(14,false)
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	var end_pos = TileHelper.tile_to_position(map.free_map_tiles[randi_range(0,map.free_map_tiles.size()-1)])
	tween.tween_property(self, "position", end_pos, 0.4)
	print("im gone now!")
	await tween.finished
	dragon_fly_area.set_collision_mask_value(14,true)

func change_appereance():
	match catches_left:
		2:
			print("appereance2")
			cpu_particles_2d.color = Color(1.0, 0.963, 0.27)
		1:
			print("appereance1")
			cpu_particles_2d.color = Color(0.27, 1.0, 0.659)
		0:
			print("appereance0")
			dragon_fly_animation_player.play("collected_anim")

func _on_dragon_fly_area_area_entered(area: Area2D) -> void:
	decrement_catches()
	fly_away()
