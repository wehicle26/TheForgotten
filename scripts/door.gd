extends StaticBody2D

@export var locked = false 
@export var bathroom_door = false
@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer
@onready var area_2d = $Area2D

var open = false

func open_door():
	if not open and not locked:
		open = true
		animation_player.speed_scale = 1
		if bathroom_door:
			animation_player.play("default")
		else:
			animation_player.play("opening")
		SoundManager.play_custom_sound(global_transform, "event:/door_open", .7)
		timer.start()


func close_door():
	if open:
		open = false
		animation_player.speed_scale = 2.0
		if bathroom_door:
			animation_player.play_backwards("default")
		else:
			animation_player.play_backwards("opening")
		SoundManager.play_custom_sound(global_transform, "event:/door_close", .7)
		timer.stop()


func _on_area_2d_body_entered(body):
	open_door()


func _on_timer_timeout():
	if open and not area_2d.has_overlapping_bodies():
		close_door()
	else:
		timer.start()
