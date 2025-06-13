extends Node2D

@onready var fruit_element_area: FruitElement = $FruitElementArea
@onready var solid_element_area: SolidElement = $SolidElementArea

func _process(delta: float) -> void:
	print(fruit_element_area.has_overlapping_areas())
	
	
