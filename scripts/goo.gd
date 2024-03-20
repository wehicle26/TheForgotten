extends StaticBody2D

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("clean")


func show_goo():
	SoundManager.play_custom_sound(global_transform, "event:/goo", 0.6)
	animation_player.play("goo")
	SoundManager.play_heartbeat()

func hide_goo():
	animation_player.play("clean")
	SoundManager.stop_heartbeat()
