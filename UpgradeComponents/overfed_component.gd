extends Node

var shop:Shop
var upgrade_card_scene = load("res://Shop/UpgradeCards/upgrade_card.tscn")

func _ready():
	shop = get_parent()
	for slot in shop.passive_slots:
		var dead_mouse: UpgradeCard = upgrade_card_scene.instantiate()
		slot.find_child("Area2D").add_child(dead_mouse)
		dead_mouse.owned_slot_area = slot.find_child("Area2D")
		dead_mouse.is_bought = true
		dead_mouse.card_sprite.frame = 65
		dead_mouse.position += Vector2(randi_range(-30,30),randi_range(-30,30))
		dead_mouse._snap_to_slot(slot.find_child("Area2D"))
	for slot in shop.active_slots:
		var dead_mouse: UpgradeCard = upgrade_card_scene.instantiate()
		slot.find_child("Area2D").add_child(dead_mouse)
		dead_mouse.owned_slot_area = slot.find_child("Area2D")
		dead_mouse.is_bought = true
		dead_mouse.card_sprite.frame = 65
		dead_mouse.position += Vector2(randi_range(-30,30),randi_range(-30,30))
		dead_mouse._snap_to_slot(slot.find_child("Area2D"))
	for slot in shop.bodymod_slots:
		var dead_mouse: UpgradeCard = upgrade_card_scene.instantiate()
		slot.find_child("Area2D").add_child(dead_mouse)
		dead_mouse.owned_slot_area = slot.find_child("Area2D")
		dead_mouse.is_bought = true
		dead_mouse.card_sprite.frame = 65
		dead_mouse.position += Vector2(randi_range(-30,30),randi_range(-30,30))
		dead_mouse._snap_to_slot(slot.find_child("Area2D"))
	for slot in shop.synergy_slots:
		var dead_mouse: UpgradeCard = upgrade_card_scene.instantiate()
		slot.find_child("Area2D").add_child(dead_mouse)
		dead_mouse.owned_slot_area = slot.find_child("Area2D")
		dead_mouse.is_bought = true
		dead_mouse.card_sprite.frame = 65
		dead_mouse.position += Vector2(randi_range(-30,30),randi_range(-30,30))
		dead_mouse._snap_to_slot(slot.find_child("Area2D"))
