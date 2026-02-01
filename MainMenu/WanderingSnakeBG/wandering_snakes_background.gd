extends Node2D

const WANDERING_SNAKE_HEAD = preload("res://MainMenu/WanderingSnakeBG/wandering_snake_head.tscn")

func _ready() -> void:
	while true:
		var wandering_snake_head = WANDERING_SNAKE_HEAD.instantiate()
		add_child(wandering_snake_head)
		wandering_snake_head.spawn(Vector2(randi_range(100,1800),randi_range(100,980)))
		wandering_snake_head.move_in_random_direction()
		await  get_tree().create_timer(randi_range(1,5)).timeout
