extends AnimatedSprite


# destroy self when animation is finished.
func _on_Explosion_animation_finished():
	queue_free()
