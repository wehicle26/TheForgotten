extends Weapon

class_name Gun

signal out_of_ammo

@onready var bullet_spawn = $BulletSpawn
@onready var muzzle_flash_1 = $BulletSpawn/MuzzleFlash1
@onready var muzzle_flash_2 = $BulletSpawn/MuzzleFlash2
@onready var muzzle_flash = $BulletSpawn/MuzzleFlash
@onready var line_2d = $BulletSpawn/Line2D
@onready var ray_cast_2d = $BulletSpawn/RayCast2D
@onready var ray_cast_2d_2 = $BulletSpawn/RayCast2D2
@onready var gpu_particles_2d = $BulletSpawn/GPUParticles2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var reload_timer = $ReloadTimer
@onready var attack_timer = $AttackTimer
@onready var bullet_scene: PackedScene = preload("res://scenes/Bullet.tscn")

@export var attack_damage = 1;
@export var knockback_force = 1;
@export var stun_time = .01;
@export var num_bullets = 1
@export var clip_size = 6

var player: Player
var bullets_in_clip
var collision_point: Vector2
var beam_speed = randf_range(0.4, 0.8)
var beam_wobble = randf_range(0.05, 0.2)
var beam_xStretch = randf_range(2, 4)

func _ready():
	bullets_in_clip = clip_size
	player = get_parent()


func _process(_delta):
	if bullets_in_clip == -1:
		out_of_ammo.emit()
	if player.arm_timer.is_stopped():
		hide()
		#position = Vector2(9, -6)
		#z_index = 0
		#animated_sprite_2d.set_animation("holster")


func _physics_process(_delta):
		collision_point = ray_cast_2d_2.get_collision_point()
		if ray_cast_2d.is_colliding() and ray_cast_2d.get_collider() is Hitbox:
			var attack = Attack.new()
			attack.attack_damage = attack_damage
			attack.knockback_force = knockback_force
			attack.attack_position = global_position
			attack.stun_time = stun_time
			ray_cast_2d.get_collider().damage(attack)
			ray_cast_2d.enabled = false


func reload():
	print("reloading")
	reload_timer.start()
	#audio_stream_player_2d.set_stream(RELOAD_BLASTER)
	#audio_stream_player_2d.play()
	SoundManager.play_custom_sound(global_transform, "event:/blaster_reload", .8)
	bullets_in_clip = clip_size
	await reload_timer.timeout
	animated_sprite_2d.set_frame(3)


func fire_gun():
	position = Vector2(9, -16)
	z_index = 1
	#get_parent().animation_player.play("Walk_Shoot")
	animated_sprite_2d.set_animation("fire")
	show()
	if reload_timer.is_stopped() and attack_timer.is_stopped():
		bullets_in_clip -= 1
		print(bullets_in_clip)
		if bullets_in_clip == -1:
			#audio_stream_player_2d.set_stream(BLASTER_CLICK)
			#audio_stream_player_2d.play()
			return
			
		var pitch = randf_range(.6, .8)
		SoundManager.play_custom_sound(global_transform, "event:/blaster_shoot", 0.4, pitch)
		#audio_stream_player_2d.set_stream(LASER_SHOT_SILENCED)
		#audio_stream_player_2d.play()

		animated_sprite_2d.set_frame(bullets_in_clip)
		muzzle_flash.show()
		muzzle_flash.play("shoot")
		#muzzle_flash_2.show()
		#muzzle_flash_2.play("shoot")
		attack_timer.start()
		if num_bullets == 1:
			player.arm_timer.start()
			shoot_laser()

		await muzzle_flash.animation_finished
		#and muzzle_flash_2.animation_finished
		
		muzzle_flash.hide()
		muzzle_flash_2.hide()


func shoot_laser():
	#player.apply_shake()
	gpu_particles_2d.emitting = true
	#line_2d = Line2D.new()
	#line_2d.position.x = 2
	#line_2d.position.y = 23
	#line_2d.rotation = -PI/2
	line_2d.clear_points()
	line_2d.add_point(ray_cast_2d.position)
	if ray_cast_2d_2.is_colliding():
		line_2d.add_point(to_local(collision_point))
	else:
		line_2d.add_point(Vector2(0, -200))
		
	beam_speed = randf_range(0.4, 0.8)
	beam_wobble = randf_range(0.05, 0.2)
	beam_xStretch = randf_range(2, 4)
	line_2d.material.set_shader_parameter("speed", beam_speed)
	#line_2d.material.set_shader_parameter("laserSize", randf_range(0.4, 0.8))
	line_2d.material.set_shader_parameter("wobbliness", beam_wobble)
	line_2d.material.set_shader_parameter("xStretch", beam_xStretch)
	
	var tween1 = get_tree().create_tween()
	tween1.tween_property(self, "beam_speed", beam_speed - 0.2, .2).set_trans(Tween.TRANS_BACK)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(self, "beam_wobble", beam_wobble - 0.1, .2).set_trans(Tween.TRANS_BACK)
	var tween3 = get_tree().create_tween()
	tween3.tween_property(self, "beam_xStretch", beam_xStretch - 1, .2).set_trans(Tween.TRANS_BACK)
	
	line_2d.visible = true
	ray_cast_2d.enabled = true
	await get_tree().create_timer(.2).timeout
	line_2d.visible = false
	#line_2d.queue_free()


func spawn_bullet(pos, rot):
	var bullet: Bullet = bullet_scene.instantiate()
	var _direction_to_mouse = (
		(get_global_mouse_position() - bullet_spawn.global_position).normalized()
	)
	bullet.set_global_position(pos)
	bullet.set_global_rotation(rot)
	get_parent().get_parent().add_child(bullet)


func _on_out_of_ammo():
	reload()
