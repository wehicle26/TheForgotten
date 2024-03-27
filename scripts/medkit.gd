extends Area2D


func _on_body_entered(body):
	if body is Player:
		body.health.health = body.health.max_health
		body.health.healthChanged.emit()
		SoundManager.play_custom_sound(global_transform, "event:/medkit", 0.8)
		queue_free()
