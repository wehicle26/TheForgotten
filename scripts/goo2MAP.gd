extends Item

@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer

var open = false

func _ready():
	interact = Callable(self, "_on_interact")
	animation_player.play("static")
	animation_player.animation_set_next("opening", "map")
	animation_player.animation_set_next("fuzzy", "map")
	timer.wait_time = randf_range(1, 5)
	SoundManager.play_custom_sound(global_transform, "event:/map_hum", .4)


func _on_interact(): 
	if not open:
		open = true
		SoundManager.play_custom_sound(global_transform, "event:/map_open", .9)
		animation_player.play("opening")
	else:
		open = false
		SoundManager.play_custom_sound(global_transform, "event:/map_off", .4)
		animation_player.play("static")


func _on_timer_timeout():
	if open:
		SoundManager.play_custom_sound(global_transform, "event:/map_fuzzy", .2)
		animation_player.play("fuzzy")
		timer.wait_time = randf_range(1, 5)
