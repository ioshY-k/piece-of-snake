extends TextureButton

@onready var select_circle: SelectCircle = $SelectCircle


func _on_mouse_entered() -> void:
	select_circle.appear()


func _on_mouse_exited() -> void:
	select_circle.disappear()
