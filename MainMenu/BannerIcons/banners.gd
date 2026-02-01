extends GridContainer

@export var gamemode = GameConsts.GAMEMODES.EASY

func _ready() -> void:
	var mode = TextConsts.get_id_string(GameConsts.GAMEMODES, gamemode)
	
	for child in get_children():
		child.get_child(0).frame = 1
	
	for key in GlobalSettings.masteries[mode]:
		if GlobalSettings.masteries[mode][key]:
			for child in get_children():
				if child.is_in_group(key):
					child.get_child(0).frame = 0
