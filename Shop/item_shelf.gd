class_name ItemShelf extends Sprite2D

@onready var itemslot_1: Sprite2D = $Itemslot1
@onready var itemslot_2: Sprite2D = $Itemslot2
@onready var itemslot_3: Sprite2D = $Itemslot3

@onready var upgrade_info: Sprite2D = $UpgradeInfo
var current_description_id: int
@onready var map_preview: Sprite2D = $MapPreview
@onready var mapmod_info: Sprite2D = $MapmodInfo


var mapmod_descriptions = {
	str(GameConsts.MAP_MODS.CAFFEINATED) : "Move Faster than usual",
	str(GameConsts.MAP_MODS.TAILVIRUS) : "Your Tail surrounds an aura, which steals fruit on contact",
	str(GameConsts.MAP_MODS.EDIBLE_PAPER) : "Using active Items causes the Snake to grow",
	str(GameConsts.MAP_MODS.LASER) : "Lasers shoot over the map, that have to be avoided",
	str(GameConsts.MAP_MODS.FRUIT_BODY) : "Surpassing your own body leves a permanent Block at that place",
	str(GameConsts.MAP_MODS.TETRI_FRUIT) : "Collected Fruits form a shape inside your body",
	str(GameConsts.MAP_MODS.MOVING_FRUIT) : "Fruits occasionally move around",
	str(GameConsts.MAP_MODS.ANTI_MAGNET) : "Stopping in place causes fruits to move away from you"
}
	

var upgrade_info_tween: Tween
func change_item_description(upgrade_card: UpgradeCard):
	if upgrade_card.upgrade_id != current_description_id:
		#new description tween etc
		if GameConsts.node_being_dragged != null and GameConsts.node_being_dragged != upgrade_card:
			return
		if upgrade_info_tween != null and upgrade_info_tween.is_running():
			upgrade_info_tween.stop()
		upgrade_info.get_node("UpgradeInfoText").text = upgrade_card.upgrade_description
		upgrade_info.show()
		upgrade_info.scale = Vector2(0.1,0.1)
		upgrade_info.global_position = upgrade_card.global_position
		upgrade_info_tween = create_tween().set_parallel().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		upgrade_info_tween.tween_property(upgrade_info, "position", Vector2(198,904), 0.6)
		upgrade_info_tween.tween_property(upgrade_info, "scale", Vector2(1,1), 1)

		current_description_id = upgrade_card.upgrade_id

var mapmod_info_tween:Tween
func show_mapmod_description(upcoming_mapmod: int):
	mapmod_info_tween = create_tween().set_parallel().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	mapmod_info_tween.tween_property(mapmod_info, "position", Vector2(318.018,609.955), 0.6)
	mapmod_info_tween.tween_property(mapmod_info, "scale", Vector2(1,1), 1)
	mapmod_info.get_node("MapmodInfoText").text = mapmod_descriptions[str(upcoming_mapmod)]
	
func hide_mapmod_description():
	mapmod_info_tween = create_tween().set_parallel().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	mapmod_info_tween.tween_property(mapmod_info, "position", Vector2(417.566,399.095), 0.6)
	mapmod_info_tween.tween_property(mapmod_info, "scale", Vector2(0.1,0.1), 1)

func set_map_preview(preview_index: int, map: int):
	map_preview.get_child(preview_index).frame = map

func set_map_covering(preview_index: int):
	map_preview.get_child(preview_index).get_node("Covering").hide()
