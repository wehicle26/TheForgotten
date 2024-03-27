extends Node2D

class_name Spit

@export var speed = 700
@export var knockback_force = 200
@export var stun_time = 5
@onready var gpu_particles_2d = $GPUParticles2D

var attack_damage = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	global_rotation += global_rotation + [ PI/32, - PI/32, PI/64, -PI/64, PI/128, -PI/128 ].pick_random() 
	#var velocity = Vector2(speed, 0.0)
	#global_rotation -= PI / 2
	#set_linear_velocity(velocity.rotated(global_rotation))


func _physics_process(delta):
	position += transform.x * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_hitbox_area_entered(area):
	if area is Hitbox:
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.knockback_force = knockback_force
		attack.attack_position = global_position
		attack.stun_time = stun_time
		area.damage(attack)

	queue_free()
