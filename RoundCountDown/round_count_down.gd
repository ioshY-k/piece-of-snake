class_name RoundCountDown extends Node2D

signal count_down_finished
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var count_down_panel: Node2D = $CountDownPanel
@onready var mod_info: Label = $CountDownPanel/CountdownPanelFG/ModInfo
@onready var map_preview: MapPreview = $CountDownPanel/MapPreview

var level:LevelManager

func _ready() -> void:
	level = get_parent()
	level.time_meter.stop_timer()
	
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
