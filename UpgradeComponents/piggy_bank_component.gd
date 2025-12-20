extends Node

func self_destruct():
	var run_manager: RunManager = get_parent().get_parent()
	GameConsts.FRUIT_THRESHOLDS[run_manager.current_act*4+\
								run_manager.current_round\
								+1] = max(1,
								GameConsts.FRUIT_THRESHOLDS[run_manager.current_act*4+\
								run_manager.current_round\
								+1] - 5)
	queue_free()
