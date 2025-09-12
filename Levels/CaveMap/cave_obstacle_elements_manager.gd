extends Node2D

func _ready():
	offset_path(get_child(-1),52)
	offset_path(get_child(-2),52)
	offset_path(get_child(-3),52)
	offset_path(get_child(-4),52)
	offset_path(get_child(-5),52)
	
	offset_path(get_child(5),38)
	offset_path(get_child(6),38)
	offset_path(get_child(7),38)
	offset_path(get_child(8),38)
	offset_path(get_child(9),38)

func offset_path(element, offset):
	for i in range(offset):
		var p = element.path.pop_front()
		element.path.append(p)
