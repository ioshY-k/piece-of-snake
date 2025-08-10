class_name TimeMeter extends Sprite2D

@onready var time_bar: Sprite2D = $TimeMeterBg/TimeBar
@onready var indicator_path: PathFollow2D = $Path2D/IndicatorPath
@onready var indicator: Sprite2D = $Path2D/IndicatorPath/Indicator

var progress_tween: Tween
var color_tween: Tween

signal expired

var timer:float = 0.0
var effect_running := false
func _process(delta):
	if effect_running:
		timer += delta
		indicator.material.set_shader_parameter("elapsed_time", timer)
		
		# Stop when time reaches shader's duration
		var duration = indicator.material.get_shader_parameter("duration")
		if timer >= duration:
			effect_running = false

func grow_and_vanish_effect():
	timer = 0.0
	effect_running = true
	indicator.material.set_shader_parameter("elapsed_time", 0.0)
	

func initiate_time_bar(time_sec: int):
	progress_tween = create_tween().set_parallel().set_trans(Tween.TRANS_LINEAR)
	color_tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	
	progress_tween.finished.connect(get_parent()._on_timer_expired)
	
	progress_tween.tween_property(time_bar, "position:y", 1600, time_sec)
	progress_tween.tween_property(indicator_path, "progress_ratio", 1.0, time_sec)
	
	color_tween.tween_property(time_bar, "modulate", Color(0.891,0.9,0.333), time_sec * 3/5)
	color_tween.tween_property(time_bar, "modulate", Color(0.69,0.179,0.179), time_sec* 2/5)
	
func reset():
	time_bar.position.y = 0
	indicator_path.progress_ratio = 0.0
	time_bar.modulate = Color(0.574, 0.89, 0.525)

func stop_timer():
	if progress_tween.is_valid() and color_tween.is_valid():
		progress_tween.pause()
		color_tween.pause()
	
func continue_timer():
	if progress_tween.is_valid() and color_tween.is_valid():
		progress_tween.play()
		color_tween.play()

func change_timer_speed(speed_scale: float):
	progress_tween.set_speed_scale(speed_scale)
	color_tween.set_speed_scale(speed_scale)
	
