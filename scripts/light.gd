extends Sprite2D

class_name Light
const FLASHLIGHT_SWITCH_ON = preload("res://sounds/FlashlightSwitchOn_SFXB.929.wav")
const FLASHLIGHT_SWITCH_OFF = preload("res://sounds/FlashlightSwitchOff_SFXB._1.wav")
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var flicker_timer = $FlickerTimer

@export var sprite_light : PointLight2D
@export var shadow_light : PointLight2D
@export var battery : Battery

signal flashlight_toggle

func _ready():
	pass

func toggle():
	if visible:
		audio_stream_player_2d.set_stream(FLASHLIGHT_SWITCH_OFF)
		flashlight_toggle.emit(false)
	else:
		audio_stream_player_2d.set_stream(FLASHLIGHT_SWITCH_ON)
		flashlight_toggle.emit(true)
		flicker_timer.start()
	
	audio_stream_player_2d.play()
	visible = not visible

func flicker(isFlickering):
	if isFlickering:
		print("flicker")
		flicker_timer.start()
	else:
		flicker_timer.stop()
	
func _on_battery_no_power():
	visible = false
	print("darkness")


func _on_flicker_timer_timeout():
	var rand_light = randf()
	sprite_light.energy = rand_light
	shadow_light.energy = rand_light
	
	if rand_light < 0.5:
		sprite_light.energy = 1
		shadow_light.energy = 1
	elif rand_light > 0.75:
		sprite_light.energy = 0.75
		shadow_light.energy = 0.75
	
	flicker_timer.start(rand_light/randf_range(1, 20))
