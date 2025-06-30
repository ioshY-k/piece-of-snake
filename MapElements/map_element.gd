class_name MapElement extends Area2D

@onready var element_shape: CollisionShape2D = $ElementShape
@onready var map: Map = $"/root/MainSceneLoader/RunManager/Level/Map"
signal collision_with


func _ready() -> void: 
	collision_with.connect(map._on_collision_with.bind(self))
