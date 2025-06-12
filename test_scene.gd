extends Node2D

@onready var snake_body: SnakeBody = $SnakeBody
@onready var snake_body_2: SnakeBody = $SnakeBody2
@onready var snake_body_3: SnakeBody = $SnakeBody3


var testarray: Array = [snake_body, snake_body_2, snake_body_3]

func _ready() -> void:
	print(testarray)
