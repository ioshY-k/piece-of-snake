extends Node

signal stop_moving(tail_still_moves)
signal continue_moving(current_direction: int)
signal fruit_collected(fruit:FruitElement, is_real_collection:bool)
signal ghost_fruit_spawned(fruit)
signal fruit_spawned(fruit)
signal got_hit
signal got_hit_and_punished #running into solid with no invincibility (actual hit occurs)
signal round_started
signal round_over
signal act_over
signal teleported
signal overlapped
signal teleport_finished
signal tail_grows
signal tail_skip
signal pre_next_tile_reached
signal next_tile_reached
signal active_item_used
signal enough_fruits_changed(enough:bool)
signal swiss_knive_synergy(active:bool)
signal fruits_left_changed(fruits_left)
