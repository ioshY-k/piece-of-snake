extends FruitMagnetComponentBase


func _ready() -> void:
	component_shapes.append_array([$MagnetField1/ComponentShape,$MagnetField2/ComponentShape,$MagnetField3/ComponentShape])
	
	for component_shape in component_shapes:
		component_shape.shape.set_size(Vector2(GameConsts.TILE_SIZE/2, GameConsts.TILE_SIZE/2))
	component_shapes[0].position = Vector2(-GameConsts.TILE_SIZE, -GameConsts.TILE_SIZE)
	component_shapes[1].position = Vector2(0					, -2 * GameConsts.TILE_SIZE)
	component_shapes[2].position = Vector2(GameConsts.TILE_SIZE, -GameConsts.TILE_SIZE)
	get_parent().next_tile_reached.connect(_on_next_tile_reached)
	$MagnetField1.connect("area_entered", _on_area_entered)
	$MagnetField2.connect("area_entered", _on_area_entered)
	$MagnetField3.connect("area_entered", _on_area_entered)
	$MagnetField1.connect("area_exited", _on_area_exited)
	$MagnetField2.connect("area_exited", _on_area_exited)
	$MagnetField3.connect("area_exited", _on_area_exited)
