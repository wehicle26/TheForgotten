extends Weapon

class_name Gun

signal out_of_ammo

@onready var bullet_spawn = $BulletSpawn
@onready var muzzle_flash = $BulletSpawn/MuzzleFlash1
@onready var muzzle_flash_2 = $BulletSpawn/MuzzleFlash2
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var reload_timer = $ReloadTimer
@onready var attack_timer = $AttackTimer
@onready var arm_timer = $ArmTimer

@onready var audio_stream_player_2d = $AudioStreamPlayer2D

@export var bullet_scene : PackedScene = preload("res://scenes/Bullet.tscn")
const LASER_SHOT_SILENCED = preload("res://sounds/151022__bubaproducer__laser-shot-silenced.wav")
const RELOAD_BLASTER = preload("res://sounds/reload_blaster.wav")
const BLASTER_CLICK = preload("res://sounds/blaster_click.wav")

@export var num_bullets = 1

var bullets_in_clip
@export var clip_size = 6

func _ready():
	bullets_in_clip = clip_size

func _process(_delta):
	if bullets_in_clip == -1:
		out_of_ammo.emit()
	if arm_timer.is_stopped():
		position = Vector2(9, -6)
		z_index = 0
		animated_sprite_2d.set_animation("holster")
		
func reload():
	print("reloading")
	reload_timer.start()
	audio_stream_player_2d.set_stream(RELOAD_BLASTER)
	audio_stream_player_2d.play()
	bullets_in_clip = clip_size
	await reload_timer.timeout
	animated_sprite_2d.set_frame(3)
		
func fire_gun():
	position = Vector2(9, -16)
	z_index = 1
	get_parent().animation_player.play("Walk_Shoot")
	animated_sprite_2d.set_animation("fire")
	show()
	arm_timer.start()
	if reload_timer.is_stopped() and attack_timer.is_stopped():
		bullets_in_clip -= 1
		print(bullets_in_clip)
		if bullets_in_clip == -1:
			audio_stream_player_2d.set_stream(BLASTER_CLICK)
			audio_stream_player_2d.play()
			return
		
		audio_stream_player_2d.set_stream(LASER_SHOT_SILENCED)
		audio_stream_player_2d.play()

		animated_sprite_2d.set_frame(bullets_in_clip)
		muzzle_flash.show()
		muzzle_flash.play("shoot")
		muzzle_flash_2.show()
		muzzle_flash_2.play("shoot")
		attack_timer.start()
		if num_bullets == 1:
			spawn_bullet(bullet_spawn.global_position, global_rotation)
		if num_bullets == 2:
			spawn_bullet(bullet_spawn.global_position, global_rotation + PI/16)
			spawn_bullet(bullet_spawn.global_position, global_rotation - PI/16)
		if num_bullets == 3:
			spawn_bullet(bullet_spawn.global_position, global_rotation)
			spawn_bullet(bullet_spawn.global_position, global_rotation + PI/16)
			spawn_bullet(bullet_spawn.global_position, global_rotation - PI/16)
		if num_bullets == 4:
			spawn_bullet(bullet_spawn.global_position, global_rotation + PI/32)
			spawn_bullet(bullet_spawn.global_position, global_rotation - PI/32)
			spawn_bullet(bullet_spawn.global_position, global_rotation + PI/16)
			spawn_bullet(bullet_spawn.global_position, global_rotation - PI/16)
		if num_bullets == 5:
			spawn_bullet(bullet_spawn.global_position, global_rotation)
			spawn_bullet(bullet_spawn.global_position, global_rotation + PI/32)
			spawn_bullet(bullet_spawn.global_position, global_rotation - PI/32)
			spawn_bullet(bullet_spawn.global_position, global_rotation + PI/16)
			spawn_bullet(bullet_spawn.global_position, global_rotation - PI/16)
			
		await muzzle_flash.animation_finished and muzzle_flash_2.animation_finished
		
		muzzle_flash.hide()
		muzzle_flash_2.hide()	
	
func spawn_bullet(pos, rot):
	var bullet : Bullet = bullet_scene.instantiate()
	var _direction_to_mouse = (get_global_mouse_position() - bullet_spawn.global_position).normalized()
	bullet.set_global_position(pos)
	bullet.set_global_rotation(rot)
	get_parent().get_parent().add_child(bullet)


func _on_out_of_ammo():
	reload()
