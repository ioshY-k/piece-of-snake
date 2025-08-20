extends Node2D

@onready var character_0_select: TileMapLayer = $Character0Select
@onready var character_1_select: TileMapLayer = $Character1Select
@onready var character_2_select: TileMapLayer = $Character2Select
@onready var character_3_select: TileMapLayer = $Character3Select

@onready var character_selects = [	character_0_select,
									character_1_select,
									character_2_select,
									character_3_select]
var hovering_char_0_select: bool = false
var hovering_char_1_select: bool = false
var hovering_char_2_select: bool = false
var hovering_char_3_select: bool = false
var hovering_char_selects: Array[bool] = [	hovering_char_0_select,
											hovering_char_1_select,
											hovering_char_2_select,
											hovering_char_3_select]

const HOVER_SCALE_CHANGE:float = 1.2

var menu_snake_speed: float = 2

signal char_changed

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		var selected_char_index = hovering_char_selects.find(true)
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


func char_hovered(char_number):
	for char_select in hovering_char_selects:
		char_select = false
	hovering_char_selects[char_number] = true
	var tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(character_selects[char_number],"scale",Vector2(HOVER_SCALE_CHANGE,HOVER_SCALE_CHANGE),0.3)
	if not character_selects[char_number].snake_anim_plays:
		character_selects[char_number].play_snake_anim()

func char_unhovered(char_number):
	hovering_char_selects[char_number] = false
	var tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(character_selects[char_number],"scale",Vector2(1.0,1.0),0.3)
	
	
