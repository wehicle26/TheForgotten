extends CharacterBody2D

class_name Player

signal healthChanged
signal freeze
signal unfreeze

@export var attack_damage = 1
@export var walk_speed = 65
@export var run_speed = 85
@export var inventory: Inventory
@export var swinging: bool = false
@export var random_strength: float = 0.5
@export var shake_fade: float = 5.0

@onready var state_machine = $StateMachine
@onready var hitbox = $Hitbox
@onready var idle_timer = $IdleTimer
@onready var player_camera = $PlayerCamera
@onready var arm_timer = $ArmTimer
@onready var animation_player = $AnimationPlayer
#@onready var flashlight = $Flashlight
@onready var sprite_2d = $Sprite2D
@onready var health = $Health
@onready var feet = $Feet
@onready var currentHealth: int = health.max_health
@onready var max_Health: int = health.max_health
@onready var gun = $Gun

const CROSSHAIR_004 = preload("res://art/player/crosshair004.png")
var FlashlightScene: PackedScene = preload("res://scenes/Flashlight.tscn")
var GunScene: PackedScene = preload("res://scenes/Gun.tscn")

var collision: bool = false
var speed = 0
var knockback = Vector2.ZERO
var isPlaying = true
var input_dir: Vector2
var has_gun: bool = false
var current_weapon = "blaster"
var knockback_force = 500
var attack_position = 0
var stun_time = .25
var flashlight: Light 
var can_shoot: bool = false

var shake_strength: float = 0.0
var rand = RandomNumberGenerator.new()


func apply_shake():
	shake_strength = random_strength


func randomOffset():
	return Vector2(
		rand.randf_range(-shake_strength, shake_strength),
		rand.randf_range(-shake_strength, shake_strength)
	)


func _ready():
	#gun.get_node("ArmTimer").timeout.connect(_lower_arm)
	sprite_2d.material.set_shader_parameter("active", false)
	SoundManager.initialize_player_sounds(self)
	inventory = Inventory.new()
	inventory.changed.connect(_inventory_changed)


func _inventory_changed():
	if inventory.blaster and not is_instance_valid(gun):
		pass
	
	if inventory.flashlight and not is_instance_valid(flashlight):
		flashlight = FlashlightScene.instantiate()
		add_child(flashlight)


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
	apply_shake()
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
		flashlight.toggle()


func get_input():
	#if not swinging:
	input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_dir * speed + knockback
				
	if Input.is_action_pressed("shoot") and inventory.blaster and (state_machine.current_state.name == "PlayerShoot" or state_machine.current_state.name == "PlayerWalkShoot"):
		gun.fire_gun()
	else:
		can_shoot = false
		
	return input_dir


func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		player_camera.offset = randomOffset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	move_and_slide()


func _lower_arm():
	pass
	#animation_player.play("Walk")


func _on_crowbar_hitbox_area_entered(area):
	if area is Hitbox:
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.knockback_force = knockback_force
		attack.attack_position = global_position
		attack.stun_time = stun_time
		area.damage(attack)
	if area is Hitbox and area.get_parent() is BreakableDoor:
		area.get_parent().hit(attack_damage)
