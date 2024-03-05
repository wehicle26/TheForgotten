extends Sprite2D

class_name Light
const FLASHLIGHT_SWITCH_ON = preload("res://sounds/FlashlightSwitchOn_SFXB.929.wav")
const FLASHLIGHT_SWITCH_OFF = preload("res://sounds/FlashlightSwitchOff_SFXB._1.wav")
@onready var flicker_timer = $FlickerTimer
@onready var sprite_light = $SpriteLight
@onready var shadow_light = $ShadowLight

@export var light_texture: Texture2D
@export var flicker_factor = 1.0
@export var energy_factor = 1.0
@export var height = 25
@export var light_offset = 140
@export var battery: Battery

signal flashlight_toggle


func _ready():
	if get_parent() is Player:
		light_offset = 140
		rotation = -PI/2
		height = 30
		position.y = 30
	
	sprite_light.offset.x = light_offset
	shadow_light.offset.x = light_offset
	sprite_light.height = height
	shadow_light.height = height
	sprite_light.texture = light_texture
	shadow_light.texture = light_texture
	flicker_timer.wait_time = 1 + flicker_factor
	flicker_timer.start()


func turn_off():
	visible = false


func turn_on():
	visible = true


func toggle():
	if visible:
		SoundManager.play_custom_sound(global_transform, "event:/flashlight_off", 0.4)
		flashlight_toggle.emit(false)
	else:
		SoundManager.play_custom_sound(global_transform, "event:/flashlight_on", 0.4)
		flashlight_toggle.emit(true)
		flicker_timer.start()

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
		sprite_light.energy = 1 * energy_factor
		shadow_light.energy = 1 * energy_factor
	elif rand_light > 0.75:
		sprite_light.energy = 0.75 * energy_factor
		shadow_light.energy = 0.75 * energy_factor

	flicker_timer.start(flicker_factor * (1 + rand_light / randf_range(1, 20)))
