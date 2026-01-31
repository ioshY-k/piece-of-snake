class_name ItemShelf extends Sprite2D

@onready var itemslot_1: Sprite2D = $Itemslot1
@onready var itemslot_2: Sprite2D = $Itemslot2
@onready var itemslot_3: Sprite2D = $Itemslot3

@onready var upgrade_info: Node2D = $UpgradeInfo
var current_description_id: int = -1
@onready var map_preview: MapPreview = $MapPreview
@onready var mapmod_info: Sprite2D = $MapmodInfo

var mapmod_descriptions = {
	str(GameConsts.MAP_MODS.CAFFEINATED) : "Move Faster than usual",
	str(GameConsts.MAP_MODS.TAILVIRUS) : "Your Tail surrounds an aura, which steals fruit on contact",
	str(GameConsts.MAP_MODS.EDIBLE_PAPER) : "Using active Items causes the Snake to grow",
	str(GameConsts.MAP_MODS.LASER) : "Lasers shoot over the map, that have to be avoided",
	str(GameConsts.MAP_MODS.FRUIT_BODY) : "Surpassing your own body leves a permanent Block at that place",
	str(GameConsts.MAP_MODS.TETRI_FRUIT) : "Collected Fruits form a shape inside your body",
	str(GameConsts.MAP_MODS.MOVING_FRUIT) : "Fruits occasionally move around",
	str(GameConsts.MAP_MODS.ANTI_MAGNET) : "Stopping in place causes fruits to move away from you",
	str(GameConsts.MAP_MODS.GHOST_INVASION) : "Normal Fruits dont give Points and cause 1 less growth. For every collected normal Fruit, spawn Ghost Fruits",
	str(GameConsts.MAP_MODS.FAR_AWAY) : "Fruits tend to spawn far away",
	str(GameConsts.MAP_MODS.DARK) : "Darkness blocks the view and must be chased away",
	str(GameConsts.MAP_MODS.UFO) : "UFOs are blocking your view",
	str(GameConsts.MAP_MODS.HEAD_SWAP) : "Everytime you collect a fruit, your Head and Tail swap places"
}
	

var upgrade_info_tween: Tween
func change_item_description(upgrade_card: UpgradeCard):
	if upgrade_card.upgrade_id != current_description_id:
		#new description tween etc
		if GameConsts.node_being_dragged != null and GameConsts.node_being_dragged != upgrade_card:
			return
		if upgrade_info_tween != null and upgrade_info_tween.is_running():
			upgrade_info_tween.stop()
		upgrade_info.get_node("VBoxContainer/UpgradeName").text = upgrade_card.upgrade_name
		upgrade_info.get_node("VBoxContainer/UpgradeName").add_theme_color_override("default_color", upgrade_card.font_color)
		upgrade_info.get_node("VBoxContainer/UpgradeInfoText").text = upgrade_card.upgrade_description
		upgrade_info.get_node("VBoxContainer/ToolTipText").text = ""
		for keyword_description in upgrade_card.keyword_descriptions:
			upgrade_info.get_node("VBoxContainer/ToolTipText").text += keyword_description
		upgrade_info.show()
		upgrade_info.modulate.a = 0.0
		upgrade_info.position.y = 911
		upgrade_info_tween = create_tween().set_parallel().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		upgrade_info_tween.tween_property(upgrade_info, "position:y", 870, 0.5)
		upgrade_info_tween.tween_property(upgrade_info, "modulate:a", 1.0, 0.5)

		current_description_id = upgrade_card.upgrade_id

var mapmod_info_tween:Tween
func show_mapmod_description(upcoming_mapmod: int):
	if not RunSettings.mapmods_enabled:
		return
	mapmod_info_tween = create_tween().set_parallel().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	mapmod_info_tween.tween_property(mapmod_info, "scale", Vector2(1,1), 1)
	mapmod_info.get_node("MapmodInfoText").text = mapmod_descriptions[str(upcoming_mapmod)]
	
func hide_mapmod_description():
	if not RunSettings.mapmods_enabled:
		return
	mapmod_info_tween = create_tween().set_parallel().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	mapmod_info_tween.tween_property(mapmod_info, "scale", Vector2(0,0), 1)
