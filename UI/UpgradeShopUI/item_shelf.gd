class_name ItemShelf extends Sprite2D

@onready var itemslot_1: Sprite2D = $Itemslot1
@onready var itemslot_2: Sprite2D = $Itemslot2
@onready var itemslot_3: Sprite2D = $Itemslot3

@onready var upgrade_info: Sprite2D = $UpgradeInfo
var current_description_id: int

var upgrade_info_tween: Tween
func change_description(upgrade_card: UpgradeCard):
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
