extends CPUParticles2D
var ripe_level: int = 0
var riped: bool = false
var very_riped: bool = false

func _ready() -> void:
	get_parent().is_riping_fruit = true
	SignalBus.fruit_collected.connect(_on_this_fruit_collected)
	SignalBus.fruit_collected.connect(_on_other_fruit_collected)

func _on_this_fruit_collected(collected_fruit: FruitElement):
	if riped and collected_fruit == get_parent():
		SignalBus.fruit_collected.emit(null)
	if very_riped and collected_fruit == get_parent():
		SignalBus.fruit_collected.emit(null)
		
func _on_other_fruit_collected(collected_fruit: FruitElement):
	if collected_fruit == get_parent() or collected_fruit == null:
		return
	ripe_level += 1
	if ripe_level == 3:
		riped = true
		emitting = true
	if ripe_level == 5:
		very_riped = true
		create_tween().tween_property(self, "scale_amount_max", 2.5, 0.4)
