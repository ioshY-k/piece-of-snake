extends ActiveItemBase

var current_map: Map
var fleeing_fruits: Array[FruitElement]
@onready var active_item_ui: AnimatedSprite2D = $ActiveItemUI

func _ready() -> void:
	super._ready()
	active_item_slot = get_parent()
	show_behind_parent = true
	for use in range(uses):
		active_item_slot.add_light()
	
	SignalBus.next_tile_reached.connect(_flee)
	SignalBus.fruit_collected.connect(_delete_if_pacmanfruit)
	item_activated.connect(_on_item_activated)
	item_activated.connect(active_item_slot._on_item_activated.bind())
	SignalBus.round_started.connect(_set_UI)

func _set_UI():
	if uses == 1:
		active_item_ui.frame = 3
	elif uses == 1:
		active_item_ui.frame = 5
	elif uses == 2:
		active_item_ui.frame = 7

func _process(delta: float) -> void:
	if Input.is_action_just_pressed(active_item_button) and uses > 0 and not shop_phase:
		#uses-1 is the light index for the itembag to go out
		item_activated.emit(uses-1)
		uses -= 1

func _on_item_activated(_uses):
	current_map = active_item_slot.get_parent().current_map
	var ghost_fruit: FruitElement = current_map.spawn_ghost_fruit([])
	fleeing_fruits.append(ghost_fruit)

func self_destruct():
	active_item_slot.remove_lights()
	queue_free()

var counter: int = 0
func _flee():
	if counter % 2 == 0:
		for ghost_fruit in fleeing_fruits:
			ghost_fruit.move(ghost_fruit.move_type.AWAY, false)
	counter += 1

func _delete_if_pacmanfruit(fruit: FruitElement, is_real_collection: bool):
	if fleeing_fruits.find(fruit) != null:
		fleeing_fruits.erase(fruit)
