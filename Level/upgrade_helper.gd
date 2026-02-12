class_name UpgradeHelper extends Node

#Upgrade Components
var fruit_relocator_component_scene = load("res://UpgradeComponents/fruit_relocator_component.tscn")
var hyper_speed_1_component_scene = load("res://UpgradeComponents/hyper_speed_1_component.tscn")
var hyper_speed_2_component_scene = load("res://UpgradeComponents/hyper_speed_2_component.tscn")
var hyper_speed_3_component_scene = load("res://UpgradeComponents/hyper_speed_3_component.tscn")
var area_size_1_component_scene = load("res://UpgradeComponents/area_size_1_component.tscn")
var area_size_2_component_scene = load("res://UpgradeComponents/area_size_2_component.tscn")
var area_size_3_component_scene = load("res://UpgradeComponents/area_size_3_component.tscn")
var time_stop_1_component_scene = load("res://UpgradeComponents/time_stop_1_component.tscn")
var time_stop_2_component_scene = load("res://UpgradeComponents/time_stop_2_component.tscn")
var time_stop_3_component_scene = load("res://UpgradeComponents/time_stop_3_component.tscn")
var item_reloader_component_scene = load("res://UpgradeComponents/item_reloader_component.tscn")
var knot_slowmo_component_scene = load("res://UpgradeComponents/knot_slowmo.tscn")
var coating_component_scene = load("res://UpgradeComponents/coating_component.tscn")
var wormhole_component_scene = load("res://UpgradeComponents/wormhole_component.tscn")
var crossroad_1_component_scene = load("res://UpgradeComponents/crossroad_1_component.tscn")
var moulting_component_scene = load("res://UpgradeComponents/moulting_component.tscn")
var piggy_bank_component_scene = load("res://UpgradeComponents/piggy_bank_component.tscn")
var sale_component_scene = load("res://UpgradeComponents/sale_component.tscn")
var fuel_1_component_scene = load("res://UpgradeComponents/fuel_1_component.tscn")
var fuel_2_component_scene = load("res://UpgradeComponents/fuel_2_component.tscn")
var fuel_3_component_scene = load("res://UpgradeComponents/fuel_3_component.tscn")
var swiss_knive_component_scene = load("res://UpgradeComponents/swiss_knive_component.tscn")
var pacman_component_scene = load("res://UpgradeComponents/pacman_component.tscn")
var shiny_ghost_component_scene = load("res://UpgradeComponents/shiny_ghost_component.tscn")
var allergy_component_scene = load("res://UpgradeComponents/allergy_component.tscn")
var snek_1_component_scene = load("res://UpgradeComponents/snek_1_component.tscn")
var snek_2_component_scene = load("res://UpgradeComponents/snek_2_component.tscn")
var power_nap_component_scene = load("res://UpgradeComponents/power_nap_component.tscn")
var catch_component_scene = load("res://UpgradeComponents/catch_component.tscn")
var diffusion_component_scene = load("res://UpgradeComponents/diffusion_component.tscn")
var big_fruit_1_component_scene = load("res://UpgradeComponents/big_fruit_1_component.tscn")
var big_fruit_2_component_scene = load("res://UpgradeComponents/big_fruit_2_component.tscn")
var big_fruit_3_component_scene = load("res://UpgradeComponents/big_fruit_3_component.tscn")
var overfed_component_scene = load("res://UpgradeComponents/overfed_component.tscn")
var dragonfly_1_component_scene = load("res://UpgradeComponents/Dragonfly/dragonfly_1_component.tscn")
var dragonfly_2_component_scene = load("res://UpgradeComponents/Dragonfly/dragonfly_2_component.tscn")
var dragonfly_3_component_scene = load("res://UpgradeComponents/Dragonfly/dragonfly_3_component.tscn")
var may_fly_1_component_scene = load("res://UpgradeComponents/MayFly/may_fly_1_component.tscn")
var may_fly_2_component_scene = load("res://UpgradeComponents/MayFly/may_fly_2_component.tscn")
var may_fly_3_component_scene = load("res://UpgradeComponents/MayFly/may_fly_3_component.tscn")
var bumblebee_1_component_scene = load("res://UpgradeComponents/Bumblebee/bumblebee_1_component.tscn")
var bumblebee_2_component_scene = load("res://UpgradeComponents/Bumblebee/bumblebee_2_component.tscn")
var bumblebee_3_component_scene = load("res://UpgradeComponents/Bumblebee/bumblebee_3_component.tscn")
var tongue_1_component_scene = load("res://UpgradeComponents/Tongue/tongue_1_component.tscn")
var tongue_2_component_scene = load("res://UpgradeComponents/Tongue/tongue_2_component.tscn")
var fruit_area_1_component_scene = load("res://UpgradeComponents/FruitArea/fruit_area_1_component.tscn")
var fruit_area_2_component_scene = load("res://UpgradeComponents/FruitArea/fruit_area_2_component.tscn")
var fruit_area_3_component_scene = load("res://UpgradeComponents/FruitArea/fruit_area_3_component.tscn")
var hit_action_component_scene = load("res://UpgradeComponents/hit_action_component.tscn")
var ghost_fruit_reaction_component_scene = load("res://UpgradeComponents/ghost_fruit_reaction_component.tscn")
var insect_reaction_component_scene = load("res://UpgradeComponents/insect_reaction_component.tscn")
var shrink_reaction_component_scene = load("res://UpgradeComponents/shrink_reaction_component.tscn")
var insect_action_component_scene = load("res://UpgradeComponents/insect_action_component.tscn")
var active_item_action_component_scene = load("res://UpgradeComponents/active_item_action_component.tscn")
var carnivore_component_scene = load("res://UpgradeComponents/carnivore_component.tscn")

var level: LevelManager

func _ready() -> void:
	level = get_parent()

func add_upgrade(upgrade_id: int, current_active_item_slot: Sprite2D, slot: int):
	
	match upgrade_id:
		GameConsts.UPGRADE_LIST.AREA_SIZE_1:
			var area_size_1_component = area_size_1_component_scene.instantiate()
			level.add_child(area_size_1_component)
		GameConsts.UPGRADE_LIST.AREA_SIZE_2:
			var area_size_2_component = area_size_2_component_scene.instantiate()
			level.add_child(area_size_2_component)
		GameConsts.UPGRADE_LIST.AREA_SIZE_3:
			var area_size_3_component = area_size_3_component_scene.instantiate()
			level.add_child(area_size_3_component)
		GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_1:
			var fruit_relocator_component = fruit_relocator_component_scene.instantiate()
			current_active_item_slot.add_child(fruit_relocator_component)
			fruit_relocator_component.initiate_active_item(3, slot)
		GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_2:
			var fruit_relocator_component = fruit_relocator_component_scene.instantiate()
			current_active_item_slot.add_child(fruit_relocator_component)
			fruit_relocator_component.initiate_active_item(5, slot)
		GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_3:
			var fruit_relocator_component = fruit_relocator_component_scene.instantiate()
			current_active_item_slot.add_child(fruit_relocator_component)
			fruit_relocator_component.initiate_active_item(7, slot)
		GameConsts.UPGRADE_LIST.PACMAN_1:
			var pacman_component = pacman_component_scene.instantiate()
			current_active_item_slot.add_child(pacman_component)
			pacman_component.initiate_active_item(3, slot)
		GameConsts.UPGRADE_LIST.PACMAN_2:
			var pacman_component = pacman_component_scene.instantiate()
			current_active_item_slot.add_child(pacman_component)
			pacman_component.initiate_active_item(5, slot)
		GameConsts.UPGRADE_LIST.PACMAN_3:
			var pacman_component = pacman_component_scene.instantiate()
			current_active_item_slot.add_child(pacman_component)
			pacman_component.initiate_active_item(7, slot)
		GameConsts.UPGRADE_LIST.TONGUE_1:
			var tongue_component = tongue_1_component_scene.instantiate()
			current_active_item_slot.add_child(tongue_component)
			tongue_component.initiate_active_item(2, slot)
		GameConsts.UPGRADE_LIST.TONGUE_2:
			var tongue_component = tongue_2_component_scene.instantiate()
			current_active_item_slot.add_child(tongue_component)
			tongue_component.initiate_active_item(2, slot)
		GameConsts.UPGRADE_LIST.TONGUE_3:
			var tongue_component = tongue_2_component_scene.instantiate()
			current_active_item_slot.add_child(tongue_component)
			tongue_component.initiate_active_item(4, slot)
		GameConsts.UPGRADE_LIST.TIME_STOP_1:
			var time_stop_1_component = time_stop_1_component_scene.instantiate()
			current_active_item_slot.add_child(time_stop_1_component)
			time_stop_1_component.initiate_active_item(3, slot)
		GameConsts.UPGRADE_LIST.TIME_STOP_2:
			var time_stop_2_component = time_stop_2_component_scene.instantiate()
			current_active_item_slot.add_child(time_stop_2_component)
			time_stop_2_component.initiate_active_item(3, slot)
		GameConsts.UPGRADE_LIST.TIME_STOP_3:
			var time_stop_3_component = time_stop_3_component_scene.instantiate()
			current_active_item_slot.add_child(time_stop_3_component)
			time_stop_3_component.initiate_active_item(3, slot)
		GameConsts.UPGRADE_LIST.WORMHOLE_1:
			var wormhole_component = wormhole_component_scene.instantiate()
			current_active_item_slot.add_child(wormhole_component)
			wormhole_component.initiate_active_item(1, slot)
		GameConsts.UPGRADE_LIST.WORMHOLE_2:
			var wormhole_component = wormhole_component_scene.instantiate()
			current_active_item_slot.add_child(wormhole_component)
			wormhole_component.initiate_active_item(2, slot)
		GameConsts.UPGRADE_LIST.WORMHOLE_3:
			var wormhole_component = wormhole_component_scene.instantiate()
			current_active_item_slot.add_child(wormhole_component)
			wormhole_component.initiate_active_item(4, slot)
		GameConsts.UPGRADE_LIST.SNEK_1:
			var snek_1_component = snek_1_component_scene.instantiate()
			current_active_item_slot.add_child(snek_1_component)
			snek_1_component.initiate_active_item(1, slot)
		GameConsts.UPGRADE_LIST.SNEK_2:
			var snek_2_component = snek_2_component_scene.instantiate()
			current_active_item_slot.add_child(snek_2_component)
			snek_2_component.initiate_active_item(1, slot)
		GameConsts.UPGRADE_LIST.SNEK_3:
			var snek_2_component = snek_2_component_scene.instantiate()
			current_active_item_slot.add_child(snek_2_component)
			snek_2_component.initiate_active_item(3, slot)
		GameConsts.UPGRADE_LIST.HYPER_SPEED_1:
			var hyper_speed_1_component = hyper_speed_1_component_scene.instantiate()
			level.speed_boost_bar.add_child(hyper_speed_1_component)
		GameConsts.UPGRADE_LIST.HYPER_SPEED_2:
			var hyper_speed_2_component = hyper_speed_2_component_scene.instantiate()
			level.speed_boost_bar.add_child(hyper_speed_2_component)
		GameConsts.UPGRADE_LIST.HYPER_SPEED_3:
			var hyper_speed_3_component = hyper_speed_3_component_scene.instantiate()
			level.speed_boost_bar.add_child(hyper_speed_3_component)
		GameConsts.UPGRADE_LIST.FUEL_1:
			var fuel_1_component = fuel_1_component_scene.instantiate()
			level.speed_boost_bar.add_child(fuel_1_component)
		GameConsts.UPGRADE_LIST.FUEL_2:
			var fuel_2_component = fuel_2_component_scene.instantiate()
			level.speed_boost_bar.add_child(fuel_2_component)
		GameConsts.UPGRADE_LIST.FUEL_3:
			var fuel_3_component = fuel_3_component_scene.instantiate()
			level.speed_boost_bar.add_child(fuel_3_component)
		GameConsts.UPGRADE_LIST.BIG_FRUIT_1:
			var big_fruit_1_component = big_fruit_1_component_scene.instantiate()
			level.add_child(big_fruit_1_component)
		GameConsts.UPGRADE_LIST.BIG_FRUIT_2:
			var big_fruit_2_component = big_fruit_2_component_scene.instantiate()
			level.add_child(big_fruit_2_component)
		GameConsts.UPGRADE_LIST.BIG_FRUIT_3:
			var big_fruit_3_component = big_fruit_3_component_scene.instantiate()
			level.add_child(big_fruit_3_component)
		GameConsts.UPGRADE_LIST.ITEM_RELOADER:
			var item_reloader_component = item_reloader_component_scene.instantiate()
			level.add_child(item_reloader_component)
		GameConsts.UPGRADE_LIST.KNOT_SLOWMO:
			var knot_slowmo_component = knot_slowmo_component_scene.instantiate()
			level.add_child(knot_slowmo_component)
		GameConsts.UPGRADE_LIST.COATING:
			var coating_component = coating_component_scene.instantiate()
			level.add_child(coating_component)
		GameConsts.UPGRADE_LIST.DIFFUSION:
			var diffusion_component = diffusion_component_scene.instantiate()
			level.add_child(diffusion_component)
		GameConsts.UPGRADE_LIST.SWISS_KNIVE:
			var swiss_knive_component = swiss_knive_component_scene.instantiate()
			level.add_child(swiss_knive_component)
		GameConsts.UPGRADE_LIST.PIGGY_BANK:
			var piggy_bank_component = piggy_bank_component_scene.instantiate()
			level.add_child(piggy_bank_component)
		GameConsts.UPGRADE_LIST.SALE:
			var sale_component = sale_component_scene.instantiate()
			level.get_parent().shop.add_child(sale_component)
		GameConsts.UPGRADE_LIST.OVERFED:
			var overfed_component = overfed_component_scene.instantiate()
			level.get_parent().shop.add_child(overfed_component)
		GameConsts.UPGRADE_LIST.MOULTING:
			var moulting_component = moulting_component_scene.instantiate()
			level.add_child(moulting_component)
		GameConsts.UPGRADE_LIST.ALLERGY:
			var allergy_component = allergy_component_scene.instantiate()
			level.add_child(allergy_component)
		GameConsts.UPGRADE_LIST.SHINY_GHOST:
			var shiny_ghost_component = shiny_ghost_component_scene.instantiate()
			level.add_child(shiny_ghost_component)
		GameConsts.UPGRADE_LIST.POWER_NAP:
			var power_nap_component = power_nap_component_scene.instantiate()
			level.add_child(power_nap_component)
		GameConsts.UPGRADE_LIST.CATCH:
			var catch_component = catch_component_scene.instantiate()
			level.add_child(catch_component)
		GameConsts.UPGRADE_LIST.CROSS_ROAD_1:
			var crossroad_1_component = crossroad_1_component_scene.instantiate()
			current_active_item_slot.add_child(crossroad_1_component)
			crossroad_1_component.initiate_active_item(1, slot)
		GameConsts.UPGRADE_LIST.CROSS_ROAD_2:
			var crossroad_2_component = crossroad_1_component_scene.instantiate()
			crossroad_2_component.big_crossroad = true
			current_active_item_slot.add_child(crossroad_2_component)
			crossroad_2_component.initiate_active_item(1, slot)
		GameConsts.UPGRADE_LIST.CROSS_ROAD_3:
			var crossroad_3_component = crossroad_1_component_scene.instantiate()
			crossroad_3_component.big_crossroad = true
			current_active_item_slot.add_child(crossroad_3_component)
			crossroad_3_component.initiate_active_item(2, slot)
		GameConsts.UPGRADE_LIST.DRAGONFLY_1:
			var dragonfly_1_component = dragonfly_1_component_scene.instantiate()
			level.add_child(dragonfly_1_component)
		GameConsts.UPGRADE_LIST.DRAGONFLY_2:
			var dragonfly_2_component = dragonfly_2_component_scene.instantiate()
			level.add_child(dragonfly_2_component)
		GameConsts.UPGRADE_LIST.DRAGONFLY_3:
			var dragonfly_3_component = dragonfly_3_component_scene.instantiate()
			level.add_child(dragonfly_3_component)
		GameConsts.UPGRADE_LIST.MAYFLY_1:
			var may_fly_1_component = may_fly_1_component_scene.instantiate()
			level.add_child(may_fly_1_component)
		GameConsts.UPGRADE_LIST.MAYFLY_2:
			var may_fly_2_component = may_fly_2_component_scene.instantiate()
			level.add_child(may_fly_2_component)
		GameConsts.UPGRADE_LIST.MAYFLY_3:
			var may_fly_3_component = may_fly_3_component_scene.instantiate()
			level.add_child(may_fly_3_component)
		GameConsts.UPGRADE_LIST.BUMBLEBEE_1:
			var bumblebee_1_component = bumblebee_1_component_scene.instantiate()
			level.add_child(bumblebee_1_component)
		GameConsts.UPGRADE_LIST.BUMBLEBEE_2:
			var bumblebee_2_component = bumblebee_2_component_scene.instantiate()
			level.add_child(bumblebee_2_component)
		GameConsts.UPGRADE_LIST.BUMBLEBEE_3:
			var bumblebee_3_component = bumblebee_3_component_scene.instantiate()
			level.add_child(bumblebee_3_component)
		GameConsts.UPGRADE_LIST.FRUIT_AREA_1:
			var fruit_area_1_component = fruit_area_1_component_scene.instantiate()
			level.add_child(fruit_area_1_component)
		GameConsts.UPGRADE_LIST.FRUIT_AREA_2:
			var fruit_area_2_component = fruit_area_2_component_scene.instantiate()
			level.add_child(fruit_area_2_component)
		GameConsts.UPGRADE_LIST.FRUIT_AREA_3:
			var fruit_area_3_component = fruit_area_3_component_scene.instantiate()
			level.add_child(fruit_area_3_component)
		GameConsts.UPGRADE_LIST.HIT_ACTION:
			var hit_action_component = hit_action_component_scene.instantiate()
			level.add_child(hit_action_component)
		GameConsts.UPGRADE_LIST.GHOST_FRUIT_REACTION:
			var ghost_fruit_reaction_component = ghost_fruit_reaction_component_scene.instantiate()
			level.add_child(ghost_fruit_reaction_component)
		GameConsts.UPGRADE_LIST.INSECT_REACTION:
			var insect_reaction_component = insect_reaction_component_scene.instantiate()
			level.add_child(insect_reaction_component)
		GameConsts.UPGRADE_LIST.SHRINK_REACTION:
			var shrink_reaction_component = shrink_reaction_component_scene.instantiate()
			level.add_child(shrink_reaction_component)
		GameConsts.UPGRADE_LIST.INSECT_ACTION:
			var insect_action_component = insect_action_component_scene.instantiate()
			level.add_child(insect_action_component)
		GameConsts.UPGRADE_LIST.ACTIVE_ITEM_ACTION:
			var active_item_action_component = active_item_action_component_scene.instantiate()
			level.add_child(active_item_action_component)
		GameConsts.UPGRADE_LIST.CARNIVORE:
			var carnivore_component = carnivore_component_scene.instantiate()
			level.add_child(carnivore_component)
		GameConsts.UPGRADE_LIST.FRUIT_MAGNET_1,\
		GameConsts.UPGRADE_LIST.FRUIT_MAGNET_2,\
		GameConsts.UPGRADE_LIST.FRUIT_MAGNET_3,\
		GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_1,\
		GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_2,\
		GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_3,\
		GameConsts.UPGRADE_LIST.EDGE_WRAP,\
		GameConsts.UPGRADE_LIST.DANCE,\
		GameConsts.UPGRADE_LIST.CORNER_PHASING,\
		GameConsts.UPGRADE_LIST.TAIL_CUT,\
		GameConsts.UPGRADE_LIST.STEEL_HELMET,\
		GameConsts.UPGRADE_LIST.ANCHOR,\
		GameConsts.UPGRADE_LIST.DIET_1,\
		GameConsts.UPGRADE_LIST.DIET_2,\
		GameConsts.UPGRADE_LIST.DIET_3,\
		GameConsts.UPGRADE_LIST.MAGIC_FLUTE_1,\
		GameConsts.UPGRADE_LIST.MAGIC_FLUTE_2,\
		GameConsts.UPGRADE_LIST.MAGIC_FLUTE_3,\
		GameConsts.UPGRADE_LIST.RUBBER_BAND,\
		GameConsts.UPGRADE_LIST.HALF_GONE,\
		GameConsts.UPGRADE_LIST.IMMUTABLE,\
		GameConsts.UPGRADE_LIST.HEAD_LIGHT,\
		GameConsts.UPGRADE_LIST.PLANT_SNAKE:
			level.current_map.add_upgrade_component(upgrade_id)

func find_and_destroy_upgrade(upgrade_id):
	var component
	match upgrade_id:
		GameConsts.UPGRADE_LIST.AREA_SIZE_1:
			component = level.find_child("AreaSize1Component",false,false)
		GameConsts.UPGRADE_LIST.AREA_SIZE_2:
			component = level.find_child("AreaSize2Component",false,false)
		GameConsts.UPGRADE_LIST.AREA_SIZE_3:
			component = level.find_child("AreaSize3Component",false,false)
		GameConsts.UPGRADE_LIST.FRUIT_MAGNET_1:
			component = level.current_map.snake_head.find_child("FruitMagnet1Component",false,false)
		GameConsts.UPGRADE_LIST.FRUIT_MAGNET_2:
			component = level.current_map.snake_head.find_child("FruitMagnet2Component",false,false)
		GameConsts.UPGRADE_LIST.FRUIT_MAGNET_3:
			component = level.current_map.snake_head.find_child("FruitMagnet3Component",false,false)
		GameConsts.UPGRADE_LIST.DIET_1:
			component = level.current_map.snake_tail.find_child("Diet1Component",false,false)
		GameConsts.UPGRADE_LIST.DIET_2:
			component = level.current_map.snake_tail.find_child("Diet2Component",false,false)
		GameConsts.UPGRADE_LIST.DIET_3:
			component = level.current_map.snake_tail.find_child("Diet3Component",false,false)
		GameConsts.UPGRADE_LIST.IMMUTABLE:
			component = level.current_map.find_child("ImmutableComponent",false,false)
		GameConsts.UPGRADE_LIST.MAGIC_FLUTE_1:
			component = level.current_map.find_child("MagicFlute1Component",false,false)
		GameConsts.UPGRADE_LIST.MAGIC_FLUTE_2:
			component = level.current_map.find_child("MagicFlute2Component",false,false)
		GameConsts.UPGRADE_LIST.MAGIC_FLUTE_3:
			component = level.current_map.find_child("MagicFlute3Component",false,false)
		GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_1,\
		GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_2,\
		GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_3:
			component = level.active_item_slot_1.find_child("FruitRelocatorComponent", false, false)
		GameConsts.UPGRADE_LIST.PACMAN_1,\
		GameConsts.UPGRADE_LIST.PACMAN_2,\
		GameConsts.UPGRADE_LIST.PACMAN_3:
			component = level.active_item_slot_1.find_child("PacmanComponent", false, false)
			if component == null:
				component = level.active_item_slot_2.find_child("PacmanComponent", false, false)
		GameConsts.UPGRADE_LIST.TONGUE_1:
			component = level.active_item_slot_1.find_child("Tongue1Component", false, false)
			if component == null:
				component = level.active_item_slot_2.find_child("Tongue1Component", false, false)
		GameConsts.UPGRADE_LIST.TONGUE_2,\
		GameConsts.UPGRADE_LIST.TONGUE_3:
			component = level.active_item_slot_1.find_child("Tongue2Component", false, false)
			if component == null:
				component = level.active_item_slot_2.find_child("Tongue2Component", false, false)
		GameConsts.UPGRADE_LIST.SNEK_1:
			component = level.active_item_slot_1.find_child("Snek1Component", false, false)
			if component == null:
				component = level.active_item_slot_2.find_child("Snek1Component", false, false)
		GameConsts.UPGRADE_LIST.SNEK_2,\
		GameConsts.UPGRADE_LIST.SNEK_3:
			component = level.active_item_slot_1.find_child("Snek2Component", false, false)
			if component == null:
				component = level.active_item_slot_2.find_child("Snek2Component", false, false)
		GameConsts.UPGRADE_LIST.CROSS_ROAD_1,\
		GameConsts.UPGRADE_LIST.CROSS_ROAD_2,\
		GameConsts.UPGRADE_LIST.CROSS_ROAD_3:
			component = level.active_item_slot_1.find_child("Crossroad1Component", false, false)
			if component == null:
				component = level.active_item_slot_2.find_child("Crossroad1Component", false, false)
		GameConsts.UPGRADE_LIST.TIME_STOP_1:
			component = level.active_item_slot_1.find_child("TimeStop1Component",false,false)
			if component == null:
				component = level.active_item_slot_2.find_child("TimeStop1Component", false, false)
		GameConsts.UPGRADE_LIST.TIME_STOP_2:
			component = level.active_item_slot_1.find_child("TimeStop2Component",false,false)
			if component == null:
				component = level.active_item_slot_2.find_child("TimeStop2Component", false, false)
		GameConsts.UPGRADE_LIST.TIME_STOP_3:
			component = level.active_item_slot_1.find_child("TimeStop3Component",false,false)
			if component == null:
				component = level.active_item_slot_2.find_child("TimeStop3Component", false, false)
		GameConsts.UPGRADE_LIST.WORMHOLE_1,\
		GameConsts.UPGRADE_LIST.WORMHOLE_2,\
		GameConsts.UPGRADE_LIST.WORMHOLE_3:
			component = level.active_item_slot_1.find_child("WormholeComponent",false,false)
			if component == null:
				component = level.active_item_slot_2.find_child("WormholeComponent", false, false)
		GameConsts.UPGRADE_LIST.HYPER_SPEED_1:
			component = level.speed_boost_bar.find_child("HyperSpeed1Component",false,false)
		GameConsts.UPGRADE_LIST.HYPER_SPEED_2:
			component = level.speed_boost_bar.find_child("HyperSpeed2Component",false,false)
		GameConsts.UPGRADE_LIST.HYPER_SPEED_3:
			component = level.speed_boost_bar.find_child("HyperSpeed3Component",false,false)
		GameConsts.UPGRADE_LIST.FUEL_1:
			component = level.speed_boost_bar.find_child("Fuel1Component",false,false)
		GameConsts.UPGRADE_LIST.FUEL_2:
			component = level.speed_boost_bar.find_child("Fuel2Component",false,false)
		GameConsts.UPGRADE_LIST.FUEL_3:
			component = level.speed_boost_bar.find_child("Fuel3Component",false,false)
		GameConsts.UPGRADE_LIST.BIG_FRUIT_1:
			component = level.find_child("BigFruit1Component",false,false)
		GameConsts.UPGRADE_LIST.BIG_FRUIT_2:
			component = level.find_child("BigFruit2Component",false,false)
		GameConsts.UPGRADE_LIST.BIG_FRUIT_3:
			component = level.find_child("BigFruit3Component",false,false)
		GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_1:
			component = level.current_map.find_child("DoubleFruit1Component",false,false)
		GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_2:
			component = level.current_map.find_child("DoubleFruit2Component",false,false)
		GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_3:
			component = level.current_map.find_child("DoubleFruit3Component",false,false)
		GameConsts.UPGRADE_LIST.EDGE_WRAP:
			component = level.current_map.find_child("EdgeWrapComponent",false,false)
		GameConsts.UPGRADE_LIST.DANCE:
			component = level.current_map.find_child("DanceComponent",false,false)
		GameConsts.UPGRADE_LIST.TAIL_CUT:
			component = level.current_map.find_child("TailCutComponent",false,false)
		GameConsts.UPGRADE_LIST.STEEL_HELMET:
			component = level.current_map.snake_head.find_child("SteelHelmetComponent",false,false)
		GameConsts.UPGRADE_LIST.ITEM_RELOADER:
			component = level.find_child("ItemReloaderComponent",false,false)
		GameConsts.UPGRADE_LIST.KNOT_SLOWMO:
			component = level.find_child("KnotSlowmo",false,false)
		GameConsts.UPGRADE_LIST.COATING:
			component = level.find_child("CoatingComponent",false,false)
		GameConsts.UPGRADE_LIST.DIFFUSION:
			component = level.find_child("DiffusionComponent",false,false)
		GameConsts.UPGRADE_LIST.PIGGY_BANK:
			component = level.find_child("PiggyBankComponent",false,false)
		GameConsts.UPGRADE_LIST.SALE:
			component = level.get_parent().shop.find_child("SaleComponent",false,false)
		GameConsts.UPGRADE_LIST.OVERFED:
			component = level.get_parent().shop.find_child("OverfedComponent",false,false)
		GameConsts.UPGRADE_LIST.CATCH:
			component = level.find_child("CatchComponent",false,false)
		GameConsts.UPGRADE_LIST.MOULTING:
			component = level.find_child("MoultingComponent",false,false)
		GameConsts.UPGRADE_LIST.ALLERGY:
			component = level.find_child("AllergyComponent",false,false)
		GameConsts.UPGRADE_LIST.CORNER_PHASING:
			component = level.current_map.find_child("CornerPhasingComponent",false,false)
		GameConsts.UPGRADE_LIST.ANCHOR:
			component = level.current_map.snake_head.find_child("AnchorComponent",false,false)
		GameConsts.UPGRADE_LIST.RUBBER_BAND:
			component = level.current_map.find_child("RubberBandComponent",false,false)
		GameConsts.UPGRADE_LIST.SWISS_KNIVE:
			component = level.find_child("SwissKniveComponent",false,false)
		GameConsts.UPGRADE_LIST.PLANT_SNAKE:
			component = level.current_map.snake_tail.find_child("PlantSnakeComponent",false,false)
		GameConsts.UPGRADE_LIST.HEAD_LIGHT:
			component = level.current_map.snake_head.find_child("HeadLightComponent",false,false)
		GameConsts.UPGRADE_LIST.SHINY_GHOST:
			component = level.find_child("ShinyGhostComponent",false,false)
		GameConsts.UPGRADE_LIST.HALF_GONE:
			component = level.current_map.find_child("HalfGoneComponent",false,false)
		GameConsts.UPGRADE_LIST.POWER_NAP:
			component = level.find_child("PowerNapComponent",false,false)
		GameConsts.UPGRADE_LIST.DRAGONFLY_1:
			component = level.find_child("Dragonfly1Component",false,false)
		GameConsts.UPGRADE_LIST.DRAGONFLY_2:
			component = level.find_child("Dragonfly2Component",false,false)
		GameConsts.UPGRADE_LIST.DRAGONFLY_3:
			component = level.find_child("Dragonfly3Component",false,false)
		GameConsts.UPGRADE_LIST.MAYFLY_1:
			component = level.find_child("MayFly1Component",false,false)
		GameConsts.UPGRADE_LIST.MAYFLY_2:
			component = level.find_child("MayFly2Component",false,false)
		GameConsts.UPGRADE_LIST.MAYFLY_3:
			component = level.find_child("MayFly3Component",false,false)
		GameConsts.UPGRADE_LIST.BUMBLEBEE_1:
			component = level.find_child("Bumblebee1Component",false,false)
		GameConsts.UPGRADE_LIST.BUMBLEBEE_2:
			component = level.find_child("Bumblebee2Component",false,false)
		GameConsts.UPGRADE_LIST.BUMBLEBEE_3:
			component = level.find_child("Bumblebee3Component",false,false)
		GameConsts.UPGRADE_LIST.FRUIT_AREA_1:
			component = level.find_child("FruitArea1Component",false,false)
		GameConsts.UPGRADE_LIST.FRUIT_AREA_2:
			component = level.find_child("FruitArea2Component",false,false)
		GameConsts.UPGRADE_LIST.FRUIT_AREA_3:
			component = level.find_child("FruitArea3Component",false,false)
		GameConsts.UPGRADE_LIST.HIT_ACTION:
			component = level.find_child("HitActionComponent",false,false)
		GameConsts.UPGRADE_LIST.GHOST_FRUIT_REACTION:
			component = level.find_child("GhostFruitReactionComponent",false,false)
		GameConsts.UPGRADE_LIST.INSECT_REACTION:
			component = level.find_child("InsectReactionComponent",false,false)
		GameConsts.UPGRADE_LIST.SHRINK_REACTION:
			component = level.find_child("ShrinkReactionComponent",false,false)
		GameConsts.UPGRADE_LIST.INSECT_ACTION:
			component = level.find_child("InsectActionComponent",false,false)
		GameConsts.UPGRADE_LIST.ACTIVE_ITEM_ACTION:
			component = level.find_child("ActiveItemActionComponent",false,false)
		GameConsts.UPGRADE_LIST.CARNIVORE:
			component = level.find_child("CarnivoreComponent",false,false)
	
	if component != null:
		component.self_destruct()
	else:
		print_debug("No Component found to be destroyed")

func determine_upgrade_reload_necessary(upgrade_id):
	match upgrade_id:
		GameConsts.UPGRADE_LIST.HYPER_SPEED_1,\
		GameConsts.UPGRADE_LIST.HYPER_SPEED_2,\
		GameConsts.UPGRADE_LIST.HYPER_SPEED_3,\
		GameConsts.UPGRADE_LIST.FUEL_1,\
		GameConsts.UPGRADE_LIST.FUEL_2,\
		GameConsts.UPGRADE_LIST.FUEL_3,\
		GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_1,\
		GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_2,\
		GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_3,\
		GameConsts.UPGRADE_LIST.PACMAN_1,\
		GameConsts.UPGRADE_LIST.PACMAN_2,\
		GameConsts.UPGRADE_LIST.PACMAN_3,\
		GameConsts.UPGRADE_LIST.TONGUE_1,\
		GameConsts.UPGRADE_LIST.TONGUE_2,\
		GameConsts.UPGRADE_LIST.TONGUE_3,\
		GameConsts.UPGRADE_LIST.TIME_STOP_1,\
		GameConsts.UPGRADE_LIST.TIME_STOP_2,\
		GameConsts.UPGRADE_LIST.TIME_STOP_3,\
		GameConsts.UPGRADE_LIST.WORMHOLE_1,\
		GameConsts.UPGRADE_LIST.WORMHOLE_2,\
		GameConsts.UPGRADE_LIST.WORMHOLE_3,\
		GameConsts.UPGRADE_LIST.ITEM_RELOADER,\
		GameConsts.UPGRADE_LIST.KNOT_SLOWMO,\
		GameConsts.UPGRADE_LIST.CROSS_ROAD_1,\
		GameConsts.UPGRADE_LIST.CROSS_ROAD_2,\
		GameConsts.UPGRADE_LIST.CROSS_ROAD_3,\
		GameConsts.UPGRADE_LIST.SALE,\
		GameConsts.UPGRADE_LIST.PIGGY_BANK,\
		GameConsts.UPGRADE_LIST.OVERFED,\
		GameConsts.UPGRADE_LIST.SNEK_1,\
		GameConsts.UPGRADE_LIST.SNEK_2,\
		GameConsts.UPGRADE_LIST.SNEK_3,\
		GameConsts.UPGRADE_LIST.BIG_FRUIT_1,\
		GameConsts.UPGRADE_LIST.BIG_FRUIT_2,\
		GameConsts.UPGRADE_LIST.BIG_FRUIT_3,\
		GameConsts.UPGRADE_LIST.FRUIT_AREA_1,\
		GameConsts.UPGRADE_LIST.FRUIT_AREA_2,\
		GameConsts.UPGRADE_LIST.FRUIT_AREA_3,\
		GameConsts.UPGRADE_LIST.SWISS_KNIVE,\
		GameConsts.UPGRADE_LIST.SHINY_GHOST,\
		GameConsts.UPGRADE_LIST.MOULTING,\
		GameConsts.UPGRADE_LIST.POWER_NAP,\
		GameConsts.UPGRADE_LIST.CARNIVORE,\
		GameConsts.UPGRADE_LIST.CATCH,\
		GameConsts.UPGRADE_LIST.DIFFUSION,\
		GameConsts.UPGRADE_LIST.DRAGONFLY_1,\
		GameConsts.UPGRADE_LIST.DRAGONFLY_2,\
		GameConsts.UPGRADE_LIST.DRAGONFLY_3,\
		GameConsts.UPGRADE_LIST.MAYFLY_1,\
		GameConsts.UPGRADE_LIST.MAYFLY_2,\
		GameConsts.UPGRADE_LIST.MAYFLY_3,\
		GameConsts.UPGRADE_LIST.BUMBLEBEE_1,\
		GameConsts.UPGRADE_LIST.BUMBLEBEE_2,\
		GameConsts.UPGRADE_LIST.BUMBLEBEE_3,\
		GameConsts.UPGRADE_LIST.ALLERGY,\
		GameConsts.UPGRADE_LIST.HIT_ACTION,\
		GameConsts.UPGRADE_LIST.GHOST_FRUIT_REACTION,\
		GameConsts.UPGRADE_LIST.INSECT_REACTION,\
		GameConsts.UPGRADE_LIST.SHRINK_REACTION,\
		GameConsts.UPGRADE_LIST.INSECT_ACTION,\
		GameConsts.UPGRADE_LIST.ACTIVE_ITEM_ACTION:
			return false
		GameConsts.UPGRADE_LIST.FRUIT_MAGNET_1,\
		GameConsts.UPGRADE_LIST.FRUIT_MAGNET_2,\
		GameConsts.UPGRADE_LIST.FRUIT_MAGNET_3,\
		GameConsts.UPGRADE_LIST.DIET_1,\
		GameConsts.UPGRADE_LIST.DIET_2,\
		GameConsts.UPGRADE_LIST.DIET_3,\
		GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_1,\
		GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_2,\
		GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_3,\
		GameConsts.UPGRADE_LIST.MAGIC_FLUTE_1,\
		GameConsts.UPGRADE_LIST.MAGIC_FLUTE_2,\
		GameConsts.UPGRADE_LIST.MAGIC_FLUTE_3,\
		GameConsts.UPGRADE_LIST.EDGE_WRAP,\
		GameConsts.UPGRADE_LIST.TAIL_CUT,\
		GameConsts.UPGRADE_LIST.STEEL_HELMET,\
		GameConsts.UPGRADE_LIST.CORNER_PHASING,\
		GameConsts.UPGRADE_LIST.ANCHOR,\
		GameConsts.UPGRADE_LIST.RUBBER_BAND,\
		GameConsts.UPGRADE_LIST.PLANT_SNAKE,\
		GameConsts.UPGRADE_LIST.HEAD_LIGHT,\
		GameConsts.UPGRADE_LIST.DANCE,\
		GameConsts.UPGRADE_LIST.HALF_GONE,\
		GameConsts.UPGRADE_LIST.IMMUTABLE,\
		GameConsts.UPGRADE_LIST.COATING:
			return true
		_:
			print_debug("not determined if upgrade reload necessary for ", upgrade_id)
			return false
