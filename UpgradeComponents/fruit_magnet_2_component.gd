extends FruitMagnetComponentBase


func _ready() -> void:
	component_shapes.append_array([	$MagnetField1/ComponentShape,
									$MagnetField2/ComponentShape,
									$MagnetField3/ComponentShape,
									$MagnetField4/ComponentShape,
									$MagnetField5/ComponentShape,
									$MagnetField6/ComponentShape,
									$MagnetField7/ComponentShape])
	
	for component_shape in component_shapes:
		component_shape.shape.set_size(Vector2(GameConsts.TILE_SIZE/2, GameConsts.TILE_SIZE/2))
	component_shapes[0].position = Vector2(-GameConsts.TILE_SIZE, -GameConsts.TILE_SIZE)
	component_shapes[1].position = Vector2(0					, -2 * GameConsts.TILE_SIZE)
	component_shapes[2].position = Vector2(GameConsts.TILE_SIZE, -GameConsts.TILE_SIZE)
	component_shapes[3].position = Vector2(2*GameConsts.TILE_SIZE, 0)
	component_shapes[4].position = Vector2(-2*GameConsts.TILE_SIZE, 0)
	component_shapes[5].position = Vector2(GameConsts.TILE_SIZE, -2 * GameConsts.TILE_SIZE)
	component_shapes[6].position = Vector2(-GameConsts.TILE_SIZE, -2 * GameConsts.TILE_SIZE)
	get_parent().next_tile_reached.connect(_on_next_tile_reached)
	$MagnetField1.connect("area_entered", _on_area_entered)
	$MagnetField2.connect("area_entered", _on_area_entered)
	$MagnetField3.connect("area_entered", _on_area_entered)
	$MagnetField4.connect("area_entered", _on_area_entered)
	$MagnetField5.connect("area_entered", _on_area_entered)
	$MagnetField6.connect("area_entered", _on_area_entered)
	$MagnetField7.connect("area_entered", _on_area_entered)
	$MagnetField1.connect("area_exited", _on_area_exited)
	$MagnetField2.connect("area_exited", _on_area_exited)
	$MagnetField3.connect("area_exited", _on_area_exited)
	$MagnetField4.connect("area_exited", _on_area_exited)
	$MagnetField5.connect("area_exited", _on_area_exited)
	$MagnetField6.connect("area_exited", _on_area_exited)
	$MagnetField7.connect("area_exited", _on_area_exited)

func self_destruct():
	queue_free()
