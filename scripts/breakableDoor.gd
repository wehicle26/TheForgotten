extends StaticBody2D

class_name BreakableDoor

@onready var collision_shape_2d = $CollisionShape2D
@onready var animated_sprite_2d = $AnimatedSprite2D
var broken = false

func hit(damage):
	if not broken:
		if damage < 2:
			SoundManager.play_custom_sound(self.global_transform, "event:/crowbar_deflect", 0.5)
		else:
			SoundManager.play_custom_sound(self.global_transform, "event:/door_smash", 0.5)
			broken = true
			animated_sprite_2d.frame = 1
			collision_shape_2d.queue_free()
