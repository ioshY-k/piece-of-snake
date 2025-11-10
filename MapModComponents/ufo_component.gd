extends Node

var map:Map
var ufo: Ufo
var following = false
var follow_counter = 0
const UFO_SCENE = preload("res://MapModComponents/Ufo/ufo.tscn")

func _ready():
	map = get_parent()
	ufo = UFO_SCENE.instantiate()
	ufo.initialize(map.snake_head, map)
	map.add_child(ufo)
	ufo.position = Vector2(500, -300)
	SignalBus.fruit_collected.connect(follow)
	SignalBus.got_hit.connect(chase_away_check)

func _process(delta: float) -> void:
	if following:
		ufo.follow_head()

func chase_away_check():
	if following:
		following = false
		ufo.chase_away()
	
func follow(_fruit, _is_real_collection):
	if following:
		return
	follow_counter += 1
	if follow_counter%2 != 0:
		return
	following = true
	await get_tree().create_timer(randi_range(4,6)).timeout
	chase_away_check()

func self_destruct():
	ufo.queue_free()
	queue_free()
