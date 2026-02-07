extends ActiveItemBase

var current_map: Map
@onready var active_item_ui: AnimatedSprite2D = $ActiveItemUI
const TONGUE = preload("res://UpgradeComponents/Tongue/tongue.tscn")

func _ready() -> void:
	super._ready()
	active_item_slot = get_parent()
	show_behind_parent = true
	for use in range(uses):
		active_item_slot.add_light()
	
	item_activated.connect(_on_item_activated)
	item_activated.connect(active_item_slot._on_item_activated.bind())

func _set_UI():
	if uses == 3:
		active_item_ui.frame = 0
	elif uses == 5:
		active_item_ui.frame = 1

func _process(delta: float) -> void:
	if Input.is_action_just_pressed(active_item_button) and uses > 0 and not shop_phase:
		#uses-1 is the light index for the itembag to go out
		item_activated.emit(uses-1)
		uses -= 1

func _on_item_activated(_uses):
	current_map = active_item_slot.get_parent().current_map
	var tongue: Tongue = TONGUE.instantiate()
	current_map.snake_head.add_child(tongue)
	tongue.tongue_area.set_collision_mask_value(1,false)

func self_destruct():
	active_item_slot.remove_lights()
	queue_free()
