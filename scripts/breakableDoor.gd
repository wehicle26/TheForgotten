extends StaticBody2D

class_name BreakableDoor

@onready var collision_shape_2d = $CollisionShape2D3
@onready var light_occluder_2d = $LightOccluder2D
@onready var light_occluder_2d_4 = $LightOccluder2D2
@onready var light_occluder_2d_5 = $LightOccluder2D3
@onready var sparks = $Sparks

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var broken = false

func hit(damage):
	if not broken:
		if damage < 2:
			SoundManager.play_custom_sound(self.global_transform, "event:/crowbar_deflect", 0.5)
			sparks.emitting = true
		else:
			SoundManager.play_custom_sound(self.global_transform, "event:/door_smash", 0.5)
			broken = true
			animation_player.play("default")
			collision_shape_2d.queue_free()
			light_occluder_2d.queue_free()
			light_occluder_2d_4.visible = true
			light_occluder_2d_5.visible = true
