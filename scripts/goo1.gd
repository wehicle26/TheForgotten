extends Goo

func _ready():
	animation_player.play("CLEAN")


func show_goo():
	animation_player.speed_scale = 0.5
	event = SoundManager.play_custom_sound(global_transform, "event:/goo", 0.6)
	animation_player.play("OOZE")

func hide_goo():
	animation_player.play("CLEAN")
	event.stop(1)
