class_name Ufo extends Node2D

var snake_head: SnakeHead
var map: Map

func initialize(_snake_head, _map) -> void:
	snake_head = _snake_head
	map = _map

func follow_head():
	position = position.lerp(snake_head.position, 0.07)

func chase_away():
	var pos
	var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	match randi()%4:
		0:
			pos = Vector2(-200,-200)
		1:
			pos = Vector2(1800,-200)
		2:
			pos = Vector2(1800,1600)
		3:
			pos = Vector2(-200,1600)
	
	tween.tween_property(self, "position", pos, 1)
