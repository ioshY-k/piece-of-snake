extends Node2D

@onready var fruits_left_number_label: Label = $FruitsLeftNumberLabel
@onready var map: Map = $Map
@onready var you_win: Label = $"YOU WIN!"
@onready var snake_head: SnakeHead = $Map/SnakeHead
@onready var snake_tail: SnakeTail = $Map/SnakeTail

func _ready() -> void:
	fruits_left_number_label.text = "4"
	map.fruit_collected.connect(_on_fruit_collected)

func _on_fruit_collected():
	fruits_left_number_label.text = str(int(fruits_left_number_label.text) - 1)
	if fruits_left_number_label.text == "0":
		fruits_left_number_label.hide()
		you_win.show()
		snake_head.you_win = true
		snake_tail.snake_speed = 0.1
	
