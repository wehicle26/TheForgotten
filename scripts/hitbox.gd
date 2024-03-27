extends Area2D

class_name Hitbox

@export var health: Health
@onready var timer = $Timer


func damage(attack: Attack):
	if health and timer.is_stopped():
		timer.start()
		print("damaged")
		if attack.attack_type == "crowbar":
			var randHitstop = randf_range(0, 1)
			if randHitstop > .75:
				HitStopManager.hit_stop_short()
		elif attack.attack_type == "blaster":
			SoundManager.play_custom_sound(global_transform, "event:/blaster_hit", .7)

		health.damage(attack)
