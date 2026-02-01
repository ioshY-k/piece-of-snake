class_name WanderingSnakeHead extends Sprite2D

var speed
var distance = 400
var current_orientation
var despawning: bool = false
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

enum DIRECTION {UP,RIGHT,DOWN,LEFT}

func _ready() -> void:
	scale = Vector2.ZERO
	cpu_particles_2d.emitting = false

func spawn(pos):
	position = pos
	while scale <= Vector2(0.27,0.27):
		scale = lerp(scale, Vector2(0.28,0.28), 0.1)
		if get_tree() != null:
			await get_tree().process_frame
	cpu_particles_2d.emitting = true

func despawn():
	despawning = true
	await get_tree().create_timer(15).timeout
	queue_free()
	

func move_in_random_direction():
	match round(rotation_degrees):
		0.0,360.0:
			current_orientation = DIRECTION.UP
		90.0:
			current_orientation = DIRECTION.RIGHT
		180.0:
			current_orientation = DIRECTION.DOWN
		270.0:
			current_orientation = DIRECTION.LEFT
			
	var dir = randi()%4
	while dir == (current_orientation+2)%4:
		dir = randi()%4
	
	var tween = create_tween().set_parallel()
	var rot: int = get_orientation(dir, rad_to_deg(rotation))
	tween.tween_property(self, "rotation", deg_to_rad(rot), 0.4)
	
	var pos: Vector2
	match dir:
		DIRECTION.UP:
			pos = Vector2(0,-distance)
		DIRECTION.RIGHT:
			pos = Vector2(distance,0)
		DIRECTION.DOWN:
			pos = Vector2(0,distance)
		DIRECTION.LEFT:
			pos = Vector2(-distance,0)
	tween.tween_property(self,"position", position + pos, 5)
	
	await tween.finished
	if position.x > 1920 or position.x < 0 or position.y > 1080 or position.y < 0:
		despawn()
	if not despawning:
		move_in_random_direction()

func get_orientation(direction: int, current_rotation: float) -> float:
	match direction:
		DIRECTION.UP:
			if abs(current_rotation-360) < abs(current_rotation-0):
				return 360
			else:
				return 0
		DIRECTION.RIGHT:
			if round(current_rotation) == 360:
				rotation_degrees = 0
			return 90
		DIRECTION.DOWN:
			return 180
		DIRECTION.LEFT:
			if current_rotation == 0:
				rotation_degrees = 360
			return 270
		_:
			return 0
