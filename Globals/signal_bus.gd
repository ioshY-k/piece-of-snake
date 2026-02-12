extends Node

signal stop_moving(tail_still_moves)
signal continue_moving(current_direction: int)
signal fruit_collected(fruit: FruitElement, is_real_collection:bool)
signal ghost_fruit_spawned(fruit)
signal fruit_spawned(fruit)
signal diffusion_happened(diffusing_bodypart)
signal got_hit
signal got_hit_and_punished #running into solid with no invincibility (actual hit occurs)
signal round_started
signal round_over
signal act_over
signal teleported
signal overlapped
signal teleport_finished #used to destroy one time teleporters
signal tail_teleported #used for tail interactions like dissolving telefruits after a teleporter
signal tail_grows
signal pre_next_tile_reached
signal next_tile_reached
signal active_item_used
signal price_calculated(upgrade_card: UpgradeCard)
signal upgrade_bought(upgrade_id: int)
signal enough_fruits_changed(enough:bool)
signal swiss_knive_synergy(active:bool)
signal fruits_left_changed(fruits_left)
signal map_paused
signal map_continued
signal action_triggered(slot_id: int)
signal insect_caught
