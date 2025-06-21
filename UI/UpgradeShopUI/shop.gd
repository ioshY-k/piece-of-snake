class_name Shop extends CanvasLayer

signal upgrade_bought
signal finished_buying

const UPGRADE_CARD = preload("res://UI/UpgradeShopUI/UpgradeCards/upgrade_card.tscn")

var upgrade_card_pool: Array[int] = [0,1,2,3]

@onready var upgrade_panel_button: Button = $UpgradeOverview/UpgradePanelButton
@onready var upgrade_overview: Sprite2D = $UpgradeOverview


var available_upgrades: Array[PackedScene] = [	load("res://UpgradeComponents/fruit_magnet_1_component.tscn"),
												load("res://UpgradeComponents/fruit_relocator_1_component.tscn")]

func _ready() -> void:
	hide_shop()

func _on_upgrade_card_bought(upgrade_id: int) -> void:
	upgrade_bought.emit(upgrade_id)


func _on_continue_next_round_pressed() -> void:
	for upgrade_card in get_tree().get_nodes_in_group("UpgradeCard"):
		if not upgrade_card.is_bought:
			upgrade_card.queue_free()
	finished_buying.emit()

func generate_items():
	var available_upgrade: int =upgrade_card_pool.pick_random()
	var upgrade_card = UPGRADE_CARD.instantiate()
	add_child(upgrade_card)
	upgrade_card.instantiate_upgrade_card( available_upgrade )
	upgrade_card_pool.erase(available_upgrade)
	print(len(upgrade_card_pool))

func show_shop():
	$ContinueNextRound.show()
	$FruitOverloadInfo.show()

func hide_shop():
	$ContinueNextRound.hide()
	$FruitOverloadInfo.hide()
	

var upgrades_expanded: bool = false
func _on_upgrade_panel_button_mouse_entered() -> void:
	var tween = create_tween()
	if not upgrades_expanded:
		tween.tween_property(upgrade_overview, "position:x", 360, 0.4).\
		set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(upgrade_panel_button, "rotation_degrees", 180, 0.25).\
		set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
		upgrades_expanded = true
	else:
		tween.tween_property(upgrade_overview, "position:x", -388, 0.4).\
		set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(upgrade_panel_button, "rotation_degrees", 0, 0.25).\
		set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
		upgrades_expanded = false
