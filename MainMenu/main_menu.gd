extends Node2D


var scene_loader: SceneLoader
@onready var character_selection: Node2D = $CharacterSelection
@onready var play_button: UpgradeCard = $PlayButton

@onready var easy_slot: Sprite2D = $EasySlot
@onready var normal_slot: Sprite2D = $NormalSlot
@onready var hard_slot: Sprite2D = $HardSlot
@onready var easy_slot_area: Area2D = $EasySlot/EasySlotArea
@onready var normal_slot_area: Area2D = $NormalSlot/NormalSlotArea
@onready var hard_slot_area: Area2D = $HardSlot/HardSlotArea

@onready var bg_colors_centipede: Sprite2D = $CharacterSelection/BGColorsCentipede
@onready var bg_colors_chameleon: Sprite2D = $CharacterSelection/BGColorsChameleon
@onready var bg_colors_ostrich: Sprite2D = $CharacterSelection/BGColorsOstrich
@onready var bg_colors_python: Sprite2D = $CharacterSelection/BGColorsPython
@onready var bg_colors_retro: Sprite2D = $CharacterSelection/BGColorsRetro
@onready var bg_colors_salamander: Sprite2D = $CharacterSelection/BGColorsSalamander
@onready var bg_colors_twohead: Sprite2D = $CharacterSelection/BGColorsTwohead
@onready var bg_colors_elephant: Sprite2D = $CharacterSelection/BGColorsElephant


var character_panels: Dictionary


func _ready() -> void:
	character_panels =  {
		str(GameConsts.CHAR_LIST.SALAMANDER) : bg_colors_salamander,
		str(GameConsts.CHAR_LIST.OSTRICH) : bg_colors_ostrich,
		str(GameConsts.CHAR_LIST.PYTHON) : bg_colors_python,
		str(GameConsts.CHAR_LIST.CHAMELEON) : bg_colors_chameleon,
		str(GameConsts.CHAR_LIST.ELEPHANT) : bg_colors_elephant,
		str(GameConsts.CHAR_LIST.TWOHEAD) : bg_colors_twohead,
		str(GameConsts.CHAR_LIST.RETRO) : bg_colors_retro,
		str(GameConsts.CHAR_LIST.CENTIPEDE) : bg_colors_centipede,
	}
	scene_loader = get_parent()
	character_selection.char_changed.connect(_on_char_changed)
	play_button.turn_into_playbutton()
	play_button.got_clicked.connect(func(_card):
		slot_rise_to(easy_slot,891)
		slot_rise_to(normal_slot,891)
		slot_rise_to(hard_slot,891))
	play_button.let_go.connect(func():
		slot_descend(easy_slot)
		slot_descend(normal_slot)
		slot_descend(hard_slot))

func _on_char_changed(char_id: int):
	RunSettings.current_char = char_id
	for panel in character_panels:
		character_panels[panel].hide()
	character_panels[str(char_id)].show()
	character_panels[str(char_id)].get_child(0).emitting = true


func create_run() -> void:
	scene_loader.change_scene("RUN_MANAGER")


func _on_easy_run_pressed() -> void:
	RunSettings.gamemode = GameConsts.GAMEMODES.EASY
	easy_slot_area.queue_free()
	normal_slot_area.queue_free()
	hard_slot_area.queue_free()
	var pos = play_button.global_position
	play_button.get_parent().remove_child(play_button)
	await get_tree().process_frame
	easy_slot.add_child(play_button)
	play_button.global_position = pos
	await get_tree().create_timer(1).timeout
	RunSettings.mapmods_enabled = false
	RunSettings.fruit_growth = 1
	create_run()


func _on_normal_run_pressed() -> void:
	RunSettings.gamemode = GameConsts.GAMEMODES.NORMAL
	easy_slot_area.queue_free()
	normal_slot_area.queue_free()
	hard_slot_area.queue_free()
	var pos = play_button.global_position
	play_button.get_parent().remove_child(play_button)
	await get_tree().process_frame
	normal_slot.add_child(play_button)
	play_button.global_position = pos
	await get_tree().create_timer(1).timeout
	RunSettings.mapmods_enabled = true
	RunSettings.fruit_growth = 1
	create_run()


func _on_hard_run_pressed() -> void:
	RunSettings.gamemode = GameConsts.GAMEMODES.HARD
	easy_slot_area.queue_free()
	normal_slot_area.queue_free()
	hard_slot_area.queue_free()
	var pos = play_button.global_position
	play_button.get_parent().remove_child(play_button)
	await get_tree().process_frame
	hard_slot.add_child(play_button)
	play_button.global_position = pos
	await get_tree().create_timer(1).timeout
	RunSettings.mapmods_enabled = true
	RunSettings.fruit_growth = 2
	create_run()

func slot_rise_to(slot, height):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(slot, "position:y", height, 0.4)

func slot_descend(slot):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(slot, "position:y", 1236.5, 0.4)

func _on_easy_slot_area_mouse_entered() -> void:
	slot_rise_to(easy_slot, 1104)

func _on_normal_slot_area_mouse_entered() -> void:
	slot_rise_to(normal_slot, 1104)

func _on_hard_slot_area_mouse_entered() -> void:
	slot_rise_to(hard_slot, 1104)

func _on_easy_slot_area_mouse_exited() -> void:
	slot_descend(easy_slot)

func _on_normal_slot_area_mouse_exited() -> void:
	slot_descend(normal_slot)

func _on_hard_slot_area_mouse_exited() -> void:
	slot_descend(hard_slot)

func _on_show_banners_mouse_entered() -> void:
	slot_rise_to(easy_slot, 560)
	slot_rise_to(normal_slot, 560)
	slot_rise_to(hard_slot, 560)

func _on_show_banners_mouse_exited() -> void:
	slot_descend(easy_slot)
	slot_descend(normal_slot)
	slot_descend(hard_slot)
