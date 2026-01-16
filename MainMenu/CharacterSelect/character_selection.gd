extends Node2D

@onready var character_0_select: TileMapLayer = $Character0Select
@onready var character_1_select: TileMapLayer = $Character1Select
@onready var character_2_select: TileMapLayer = $Character2Select
@onready var character_3_select: TileMapLayer = $Character3Select
@onready var character_4_select: TileMapLayer = $Character4Select
@onready var character_5_select: TileMapLayer = $Character5Select
@onready var character_6_select: TileMapLayer = $Character6Select
@onready var character_7_select: TileMapLayer = $Character7Select

@onready var character_selects = [	character_0_select,
									character_1_select,
									character_2_select,
									character_3_select,
									character_4_select,
									character_5_select,
									character_6_select,
									character_7_select]
var hovering_char_0_select: bool = false
var hovering_char_1_select: bool = false
var hovering_char_2_select: bool = false
var hovering_char_3_select: bool = false
var hovering_char_4_select: bool = false
var hovering_char_5_select: bool = false
var hovering_char_6_select: bool = false
var hovering_char_7_select: bool = false
var hovering_char_selects: Array[bool] = [	hovering_char_0_select,
											hovering_char_1_select,
											hovering_char_2_select,
											hovering_char_3_select,
											hovering_char_4_select,
											hovering_char_5_select,
											hovering_char_6_select,
											hovering_char_7_select]

var char_descriptions:Dictionary = {
	str(GameConsts.CHAR_LIST.OSTRICH) : "Faster than the others.",
	str(GameConsts.CHAR_LIST.PYTHON) : "The fruit requirement for every round has 1 less fruit\n\n(recommended for the first run)",
	str(GameConsts.CHAR_LIST.SALAMANDER) : "Start with a random active Item",
	str(GameConsts.CHAR_LIST.ELEPHANT) : "Carry over your Currency from one map to the next",
	str(GameConsts.CHAR_LIST.CHAMELEON) : "Gain an additional multi colored Upgrade slot (not implemented yet)",
	str(GameConsts.CHAR_LIST.TWOHEAD) : "Switch directions everytime you collect a fruit",
	str(GameConsts.CHAR_LIST.RETRO) : "When exiting the screen, enter at the opposite side. On hit you lose the game.",
	str(GameConsts.CHAR_LIST.CENTIPEDE) : "If no direction is held, you won't move forward.",
	
}
@onready var label: Label = $"../CharacterInfo/Label"


const HOVER_SCALE_CHANGE:float = 1.2

var menu_snake_speed: float = 0.06

signal char_changed

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		var selected_char_index = hovering_char_selects.find(true)
		click_animation(selected_char_index)
		if selected_char_index != -1:
			char_changed.emit(selected_char_index)

func _on_area_0_mouse_entered() -> void:
	char_hovered(0)

func _on_area_0_mouse_exited() -> void:
	char_unhovered(0)
	
func _on_area_1_mouse_entered() -> void:
	char_hovered(1)

func _on_area_1_mouse_exited() -> void:
	char_unhovered(1)
	
func _on_area_2_mouse_entered() -> void:
	char_hovered(2)

func _on_area_2_mouse_exited() -> void:
	char_unhovered(2)

func _on_area_3_mouse_entered() -> void:
	char_hovered(3)

func _on_area_3_mouse_exited() -> void:
	char_unhovered(3)
	
func _on_area_4_mouse_entered() -> void:
	char_hovered(4)

func _on_area_4_mouse_exited() -> void:
	char_unhovered(4)

func _on_area_5_mouse_entered() -> void:
	char_hovered(5)

func _on_area_5_mouse_exited() -> void:
	char_unhovered(5)

func _on_area_6_mouse_entered() -> void:
	char_hovered(6)

func _on_area_6_mouse_exited() -> void:
	char_unhovered(6)
	
func _on_area_7_mouse_entered() -> void:
	char_hovered(7)

func _on_area_7_mouse_exited() -> void:
	char_unhovered(7)

func char_hovered(char_number):
	for char_select in hovering_char_selects:
		char_select = false
	hovering_char_selects[char_number] = true
	var tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(character_selects[char_number],"position:y", character_selects[char_number].position.y-5,0.1)
	tween.tween_property(character_selects[char_number],"position:y", character_selects[char_number].position.y,0.1)
	tween.tween_property(character_selects[char_number],"position:y", character_selects[char_number].position.y-5,0.1)
	tween.tween_property(character_selects[char_number],"position:y", character_selects[char_number].position.y,0.1)
	label.text = char_descriptions[str(char_number)]
	
	

func char_unhovered(char_number):
	hovering_char_selects[char_number] = false
	var tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(character_selects[char_number],"scale",Vector2(1.0,1.0),0.3)
	

func click_animation(char_number):
	if char_number != -1 and not character_selects[char_number].snake_anim_plays:
		character_selects[char_number].play_snake_anim()
