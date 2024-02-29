extends CharacterBody2D

class_name Player

signal healthChanged
signal freeze
signal unfreeze

@export var walk_speed = 65
@export var run_speed = 85
@export var inventory: Inventory
@export var swinging: bool = false
@onready var hitbox = $Hitbox
@onready var idle_timer = $IdleTimer

@onready var animation_player = $AnimationPlayer
#@onready var flashlight = $Flashlight
@onready var sprite_2d = $Sprite2D
@onready var health = $Health
@onready var feet = $Feet
@onready var currentHealth: int = health.max_health
@onready var max_Health: int = health.max_health

const CROSSHAIR_004 = preload("res://art/player/crosshair004.png")

var collision: bool = false
var speed = 0
var knockback = Vector2.ZERO
var isPlaying = true
var input_dir: Vector2
var has_gun: bool = false
var current_weapon = "crowbar"
var attack_damage = 1
var knockback_force = 500
var attack_position = 0
var stun_time = .25


func _ready():
	#gun.get_node("ArmTimer").timeout.connect(_lower_arm)
	sprite_2d.material.set_shader_parameter("active", false)
	SoundManager.initialize_player_sounds(self)
	inventory = Inventory.new()


func play_sigh():
	SoundManager.play_custom_sound(self.global_transform, "event:/sigh", 0.3)


func play_breathe_in():
	SoundManager.play_custom_sound(self.global_transform, "event:/breathe_in", 0.3)


func play_neck_crack():
	SoundManager.play_custom_sound(self.global_transform, "event:/neck_crack", 0.3)


func freeze_player():
	freeze.emit()


func unfreeze_player():
	unfreeze.emit()


func damage():
	freeze_player()
	sprite_2d.material.set_shader_parameter("active", true)
	SoundManager.play_custom_sound(self.global_transform, "event:/roach_bite", 0.7)
	var timer = get_tree().create_timer(.5)
	await timer.timeout
	sprite_2d.material.set_shader_parameter("active", false)
	unfreeze_player()


func play_footstep():
	SoundManager.play_footstep()


func play_crowbar_swing():
	SoundManager.play_crowbar_swing()


func play_crowbar_swing_fast():
	SoundManager.play_crowbar_swing_fast()


func _input(event):
	#if event.is_action_pressed("1"):
	#gun.num_bullets = 1
	#if event.is_action_pressed("2"):
	#gun.num_bullets = 2
	#if event.is_action_pressed("3"):
	#gun.num_bullets = 3
	#if event.is_action_pressed("4"):
	#gun.num_bullets = 4
	#if event.is_action_pressed("5"):
	#gun.num_bullets = 5
	if event.is_action_pressed("flashlight_toggle") and inventory.flashlight:
		pass
		#flashlight.toggle()


func get_input():
	#if not swinging:
	input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_dir * speed + knockback
	if Input.is_action_pressed("shoot") and has_gun:
		pass
		#gun.fire_gun()
	return input_dir


func _process(_delta):
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	move_and_slide()


func _lower_arm():
	animation_player.play("Walk")


func _on_crowbar_hitbox_area_entered(area):
	if area is Hitbox:
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.knockback_force = knockback_force
		attack.attack_position = global_position
		attack.stun_time = stun_time
		area.damage(attack)
