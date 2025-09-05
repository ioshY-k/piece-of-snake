extends Node

var level: LevelManager
var follow_countdown: int = 0
@onready var allergy_timer: Timer = $AllergyTimer
var initial_duration = 6.0

func _ready():
	level = get_parent()
	level.allergy_mode = true
	_delete_all_fruit()
	SignalBus.next_tile_reached.connect(_fruit_follows)
	SignalBus.round_over.connect(_delete_all_fruit)
	allergy_timer.timeout.connect(_spawn_ghost_fruit)
	SignalBus.ghost_fruit_spawned.connect(_increment_points)
	SignalBus.fruit_collected.connect(_decrement_points)
	SignalBus.round_started.connect(_spawn_3_ghost_fruits)

func _fruit_follows():
	follow_countdown += 1
	#if follow_countdown%2 == 0:
	for fruit:FruitElement in level.current_map.find_all_fruits():
		fruit.move(fruit.move_type.TOWARDS,false)

func _delete_all_fruit():
	for fruit in level.current_map.find_all_fruits():
		fruit.queue_free()
	level.current_map.current_fruits = []
	allergy_timer.wait_time = initial_duration

func _spawn_ghost_fruit():
	if RunSettings.play_phase:
		level.current_map.spawn_ghost_fruit([])
		
func _spawn_3_ghost_fruits():
	if RunSettings.play_phase:
		for i in range(3):
			level.current_map.spawn_ghost_fruit([])

func _decrement_points(_fruit, _is_real_collection):
	level.decrement_points(1)
	allergy_timer.wait_time = max(2.3,allergy_timer.wait_time-1)

func _increment_points(_fruit):
	level.increment_points()
	
func self_destruct():
	level.allergy_mode = false
	_delete_all_fruit()
	level.current_map.spawn_fruit([])
	queue_free()
