extends Node

var level:LevelManager
var initial_fruit_punishment

func _ready():
	level = get_parent()
	initial_fruit_punishment = level.fruit_punishment
	level.fruit_punishment = 0

func _coating_used():
	level.fruit_punishment = initial_fruit_punishment
