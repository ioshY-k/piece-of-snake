class_name FruitElement extends MapElement
var particle_scene = load("res://MapElements/FruitElements/fruit_collect_particles.tscn")
var is_riping_fruit = false

func collected_anim(snakehead_pos: Vector2, fruit_destination_pos: Vector2):
	set_collision_layer_value(2,false)
	var tweenforth = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).set_parallel(true)
	tweenforth.tween_property(self, "position", position+(snakehead_pos-position).rotated(deg_to_rad(180)), 0.15)
	tweenforth.tween_property(self, "scale", Vector2(1.5,1.5), 0.15)
	await tweenforth.finished
	var tweenback = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN).set_parallel(true)
	tweenback.tween_property(self, "position", snakehead_pos, 0.1)
	tweenback.tween_property(self, "scale", Vector2.ZERO, 0.1)
	await tweenback.finished
	var particles: CPUParticles2D = particle_scene.instantiate()
	get_parent().add_child(particles)
	particles.position = fruit_destination_pos
	await get_tree().process_frame
	particles.emitting = false
	queue_free()
