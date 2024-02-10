extends CharacterBody2D

class_name Enemy

@export var speed = 100
@export var player: Node2D
@export var rotation_speed = .5
@export var attack_damage = 1
@export var knockback_force = 50
@export var stun_time = .25

@onready var navigation_agent_2d = $NavigationAgent2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var line_of_sight = $LineOfSight
@onready var aggro_timer = $AggroTimer

var current_stun_time
var is_player_spotted = false

func damage():
	print("tint")
	animated_sprite_2d.material.set_shader_parameter("active", true)
	var timer = get_tree().create_timer(0.5)
	await timer.timeout
	animated_sprite_2d.material.set_shader_parameter("active", false)
	
func _ready():
	animated_sprite_2d.material.set_shader_parameter("active", false)
	line_of_sight.player_spotted.connect(_player_spotted)

func _physics_process(_delta):
	move_and_slide()
			
func make_path():
	navigation_agent_2d.target_position = player.global_position

func path_to_player():
	var next_path_position = navigation_agent_2d.get_next_path_position()
	var directon = to_local(next_path_position).normalized()
	animated_sprite_2d.look_at(directon)
	velocity = directon * speed	

func _player_spotted():
	is_player_spotted = true
	aggro_timer.start()
	
func _on_navigation_timer_timeout():
	make_path()


func _on_aggro_timer_timeout():
	is_player_spotted = false

func _on_hitbox_area_entered(area):
	if area is Hitbox:
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.knockback_force = knockback_force
		attack.attack_position = global_position
		attack.stun_time = stun_time
		area.damage(attack)
