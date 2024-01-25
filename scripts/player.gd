extends CharacterBody2D


@export var speed = 300.0
@onready var animation_player = $AnimationPlayer
@onready var bullet_spawn = $BulletSpawn
@onready var gun = $Gun
@onready var muzzle_flash = $BulletSpawn/MuzzleFlash1
@onready var muzzle_flash_2 = $BulletSpawn/MuzzleFlash2

var bullet_scene : PackedScene = preload("res://scenes/Bullet.tscn")
var num_bullets = 1


func _ready():
	pass
	
func _input(event):
	if event.is_action_pressed("1"):
		num_bullets = 1
	if event.is_action_pressed("2"):
		num_bullets = 2
	if event.is_action_pressed("3"):
		num_bullets = 3
	if event.is_action_pressed("4"):
		num_bullets = 4
	if event.is_action_pressed("5"):
		num_bullets = 5
		
	if event.is_action_pressed("shoot"):
		fire_gun(num_bullets)

func fire_gun(num_bullets):
	animation_player.play("shoot")
	gun.show()
	muzzle_flash.show()
	muzzle_flash.play("shoot")
	muzzle_flash_2.show()
	muzzle_flash_2.play("")
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
	#await muzzle_flash_2.animation_finished
	gun.hide()
	muzzle_flash.hide()
	muzzle_flash_2.hide()
	
func spawn_bullet(pos, rot):
	var bullet : Bullet = bullet_scene.instantiate()
	bullet.set_global_position(pos)
	bullet.set_global_rotation(rot)
	get_parent().add_child(bullet)
		
func get_input():
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_dir * speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_input()
	move_and_collide(velocity * delta)
	look_at(get_global_mouse_position())
	global_rotation += PI/2
#	var vector = global_position - get_global_mouse_position()
#	var angle = vector.angle()
#	var rotaion = global_rotation
#	global_rotation= lerp(rotaion, angle, 0.2)
	
	if animation_player.is_playing():
		pass
	else:
		animation_player.play("RESET")
	if velocity != Vector2(0, 0):
		#animation_player.play("shoot")
		pass
	else:
		pass
		#animation_player.stop()
