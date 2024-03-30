extends Goo


func _ready():
	hide()


func show_goo():
	animation_player.speed_scale = 0.5
	animation_player.play("default")
	event = SoundManager.play_custom_sound(global_transform, "event:/goo", 0.6)
	show()

func hide_goo():
	hide()
	event.stop(1)
