extends StaticBody2D


func _ready():
	SoundManager.play_custom_sound(global_transform, "event:/power_core", .5)
