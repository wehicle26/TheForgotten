extends CharacterBody2D

class_name Enemy

signal hit_player

@export var default_speed = 50
@export var speed = default_speed
@export var max_speed = 130
@export var skitter_speed = 100
@export var player: Player
@export var lunge_speed = 50
@export var attack_range = 60
@export var rotation_speed = .5
@export var attack_damage = 1
@export var knockback_force = 50
@export var stun_time = .25

@onready var sprite_2d = $Sprite2D
@onready var navigation_agent_2d = $NavigationAgent2D
@onready var line_of_sight = $LineOfSight
@onready var aggro_timer = $AggroTimer
@onready var move_sound_timer = $MoveSoundTimer
@onready var gpu_particles_2d = $GPUParticles2D
@onready var animation_player = $AnimationPlayer

var current_stun_time
var is_player_spotted = false
var direction
var next_path_position

func kill(direction):
	if is_in_group("Roach"):
		gpu_particles_2d.amount = 64
		gpu_particles_2d.emitting = true
		animation_player.play("Death")
		SoundManager.play_custom_sound(global_transform, "event:/roach_splat", 0.8)
		await animation_player.animation_finished
	queue_free()


func damage():
	if is_in_group("Roach"):
		gpu_particles_2d.emitting = true
		gpu_particles_2d.process_material.direction = - Vector3(direction.x, direction.y, 0)
		SoundManager.play_custom_sound(global_transform, "event:/roach_hit", 0.5)
	sprite_2d.material.set_shader_parameter("active", true)
	var timer = get_tree().create_timer(0.5)
	await timer.timeout
	sprite_2d.material.set_shader_parameter("active", false)


func _ready():
	sprite_2d.material.set_shader_parameter("active", false)
	line_of_sight.player_spotted.connect(_player_spotted)
	SoundManager.initialize_enemy_sounds(self)


func _physics_process(_delta):
	move_and_slide()


func play_enemy_move_sound():
	SoundManager.play_enemy_move_sound(self)


func make_path():
	player = get_tree().get_first_node_in_group("Player")
	if is_instance_valid(player):
		navigation_agent_2d.target_position = player.global_position


func path_to_player():
	next_path_position = navigation_agent_2d.get_next_path_position()
	direction = to_local(next_path_position).normalized()
	sprite_2d.look_at(next_path_position)
	velocity = direction * speed


func retreat_from_player():
	next_path_position = navigation_agent_2d.get_next_path_position() * -1
	direction = to_local(next_path_position).normalized()
	sprite_2d.look_at(next_path_position)
	velocity = direction * speed


func _player_spotted():
	is_player_spotted = true
	aggro_timer.start()


func _on_navigation_timer_timeout():
	make_path()


func _on_aggro_timer_timeout():
	is_player_spotted = false


func _on_hitbox_area_entered(area):
	if area is Hitbox:
		hit_player.emit()
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.knockback_force = knockback_force
		attack.attack_position = global_position
		attack.stun_time = stun_time
		area.damage(attack)


func _on_move_sound_timer_timeout():
	play_enemy_move_sound()

