class_name RoundCountDown extends Node2D

signal count_down_finished
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var count_down_panel: Node2D = $CountDownPanel
@onready var mod_info: Label = $CountDownPanel/CountdownPanelFG/ModInfo
@onready var map_preview: MapPreview = $CountDownPanel/MapPreview
@onready var container: AnimatedSprite2D = $CountDownPanel/CountdownPanelBG/Container
@onready var count_down_bar_mask: AnimatedSprite2D = $CountDownPanel/CountDownBarMask
@onready var container_deco: AnimatedSprite2D = $CountDownPanel/CountdownPanelDeco/ContainerDeco


var container_anim_dict = {
	str(GameConsts.MAP_MODS.NO_MAPMOD) : load("res://RoundCountDown/NoMapMod/container_animations.tscn"),
	str(GameConsts.MAP_MODS.CAFFEINATED) : load("res://RoundCountDown/NoMapMod/container_animations.tscn"),
	str(GameConsts.MAP_MODS.TAILVIRUS) : load("res://RoundCountDown/TailVirus/container_animations.tscn"),
	str(GameConsts.MAP_MODS.EDIBLE_PAPER) : load("res://RoundCountDown/NoMapMod/container_animations.tscn"),
	str(GameConsts.MAP_MODS.LASER) : load("res://RoundCountDown/Laser/container_animations.tscn"),
	str(GameConsts.MAP_MODS.FRUIT_BODY) : load("res://RoundCountDown/NoMapMod/container_animations.tscn"),
	str(GameConsts.MAP_MODS.TETRI_FRUIT) : load("res://RoundCountDown/NoMapMod/container_animations.tscn"),
	str(GameConsts.MAP_MODS.MOVING_FRUIT) : load("res://RoundCountDown/NoMapMod/container_animations.tscn"),
	str(GameConsts.MAP_MODS.ANTI_MAGNET) : load("res://RoundCountDown/AntiMagnet/container_animations.tscn"),
	str(GameConsts.MAP_MODS.GHOST_INVASION) : load("res://RoundCountDown/GhostInvasion/container_animations.tscn"),
	str(GameConsts.MAP_MODS.FAR_AWAY) : load("res://RoundCountDown/FarAway/container_animations.tscn"),
	str(GameConsts.MAP_MODS.DARK) : load("res://RoundCountDown/NoMapMod/container_animations.tscn"),
	str(GameConsts.MAP_MODS.UFO) : load("res://RoundCountDown/NoMapMod/container_animations.tscn"),
	str(GameConsts.MAP_MODS.HEAD_SWAP) : load("res://RoundCountDown/NoMapMod/container_animations.tscn"),
	str(GameConsts.MAP_MODS.SLIME_TRAIL) : load("res://RoundCountDown/NoMapMod/container_animations.tscn")
}

var level:LevelManager
var _current_mapmod

func _ready() -> void:
	level = get_parent()
	level.time_meter.stop_timer()
	_current_mapmod = level.current_map.current_mapmod
	
	container.frame = _current_mapmod
	count_down_bar_mask.frame = _current_mapmod
	container_deco.frame = _current_mapmod
	var container_animation = container_anim_dict[str(_current_mapmod)].instantiate()
	container.add_child(container_animation)
	
	map_preview.set_map_covering(level.get_parent().current_act)
	for i in range(3):
		map_preview.set_map_preview(i, level.get_parent().maporder[i])
	map_preview.set_round_indicators(level.get_parent().current_act, level.get_parent().current_round)
	
	count_down_panel.visible = false
	position = Vector2(300,0)
	
	$CountDownPanel/CountdownPanelBG.self_modulate.a = 0.3
	$CountDownPanel/CountDownBarMask/CountDownBar.visible = false
	$CountDownPanel/CountDownBarMask.position.x = -973
	$CountDownPanel/CountdownPanelDeco.position.y = -107.0
	animation_player.play("countdown_anim")
	await animation_player.animation_finished
	
	level.time_meter.continue_timer()
	count_down_finished.emit()

func _process(delta: float) -> void:
	if Input.is_action_pressed("click"):
		animation_player.speed_scale = 6
	else:
		animation_player.speed_scale = 1
		

func change_text(text:String):
	mod_info.text = text
