class_name RoundCountDown extends Node2D

signal count_down_finished
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var count_down_panel: Node2D = $CountDownPanel
@onready var mod_info: Label = $CountDownPanel/CountdownPanelFG/ModInfo
var colors = [Color(0.907, 0.511, 0.662), Color(0.331, 0.682, 0.978), Color(0.127, 0.752, 0.689), Color(0.903, 0.748, 0.233), Color(0.485, 0.479, 0.945)]
var level:LevelManager

func _ready() -> void:
	level = get_parent()
	level.time_meter.stop_timer()
	count_down_panel.visible = false
	position = Vector2(300,0)
	var color = colors[randi()%colors.size()]
	$CountDownPanel/CountdownPanelDeco.modulate = color
	$CountDownPanel/CountdownPanelFG.modulate = color
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
