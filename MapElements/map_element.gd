class_name MapElement extends Area2D

@onready var element_shape: CollisionShape2D = $ElementShape
@onready var map: Map = $"/root/RunManager/Level/Map"

signal collision_with


func _ready() -> void: 
	element_shape.shape.set_size(Vector2(GameConsts.TILE_SIZE, GameConsts.TILE_SIZE))
	collision_with.connect(map._on_collision_with.bind(self))
