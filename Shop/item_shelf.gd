class_name ItemShelf extends Sprite2D

@onready var itemslot_1: Sprite2D = $Itemslot1
@onready var itemslot_2: Sprite2D = $Itemslot2
@onready var itemslot_3: Sprite2D = $Itemslot3

@onready var upgrade_info: Node2D = $UpgradeInfo
var current_description_id: int = -1
@onready var map_preview: MapPreview = $MapPreview
@onready var mapmod_info: Sprite2D = $MapmodInfo

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
	var id_string = TextConsts.get_id_string(GameConsts.MAP_MODS, upcoming_mapmod)
	mapmod_info.get_node("MapmodInfoText").text = TextConsts.get_text(TextConsts.TABLES.MAPMODS, id_string, "DESC")
	
func hide_mapmod_description():
	if not RunSettings.mapmods_enabled:
		return
	mapmod_info_tween = create_tween().set_parallel().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	mapmod_info_tween.tween_property(mapmod_info, "scale", Vector2(0,0), 1)
