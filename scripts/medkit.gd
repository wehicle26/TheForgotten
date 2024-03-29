extends Area2D

class_name Medkit
func _on_body_entered(body):
	if body is Player:
		if body.health.health != body.health.max_health:
			body.health.health = body.health.max_health
			body.health.healthChanged.emit()
			SoundManager.play_custom_sound(global_transform, "event:/medkit", 0.8)
			queue_free()
