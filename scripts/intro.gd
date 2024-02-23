extends Node2D


const HAND = preload("res://art/environment/hand.png")
const CRYO_INTERIOR_SMASHED = preload("res://art/environment/cryo_interior_smashed.png")
const MAIN = preload("res://scenes/Main.tscn")

@onready var texture_rect = $TextureRect
@onready var cutscene_player = $CutscenePlayer
@onready var camera_2d = $Camera2D
@onready var sprite_2d = $Sprite2D
@onready var sprite_2d_2 = $Sprite2D2
@onready var shard_emitter = $Sprite2D2/ShardEmitter

@export var random_strength : float = 30.0
@export var shake_fade : float = 5.0

var shake_strength : float = 0.0
var allow_input = false
var rand = RandomNumberGenerator.new()
var hit_count = 0


func apply_shake():
	shake_strength = random_strength


func randomOffset():
	return Vector2(rand.randf_range(-shake_strength, shake_strength), 
	rand.randf_range(-shake_strength, shake_strength))


func _input(event):
	if allow_input and event.is_action_pressed("shoot") and \
	SoundManager.get_let_me_out_state() != 0 and \
	hit_count <= 5:
		print(hit_count)
		play_let_me_out()
		apply_shake()
		await get_tree().create_timer(.3).timeout
		sprite_2d.visible = true
		sprite_2d.frame = hit_count
		hit_count += 1
	elif hit_count == 6 and event.is_action_pressed("shoot"):
		#play_let_me_out()
		hit_count += 1
		apply_shake()
		await get_tree().create_timer(.3).timeout
		texture_rect.visible = false
		sprite_2d.visible = false
		sprite_2d_2.visible = true
		play_shatter_glass()
		shard_emitter.shatter()
		allow_input = false
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_packed(MAIN)


func _ready():
	cutscene_player.play("Intro")
	await cutscene_player.animation_finished
	allow_player_input()


func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		camera_2d.offset = randomOffset()


func play_shatter_glass():
	SoundManager.play_shatter_glass()


func play_intro_sound():
	SoundManager.play_intro_sound()


func allow_player_input():
	allow_input = true
	Input.set_custom_mouse_cursor(HAND)


func play_let_me_out():
	SoundManager.play_let_me_out()
