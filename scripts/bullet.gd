extends RigidBody2D

class_name Bullet

@export var bullet_speed = 700
@export var knockback_force = 700
@export var stun_time = 5
@onready var gpu_particles_2d = $GPUParticles2D
@onready var ray_cast_2d = $RayCast2D

var attack_damage = 1


func _process(_delta):
	if ray_cast_2d.is_colliding():
		queue_free()


# Called when the node enters the scene tree for the first time.
func _ready():
	var velocity = Vector2(bullet_speed, 0.0)
	global_rotation -= PI / 2
	set_linear_velocity(velocity.rotated(global_rotation))


func _on_visible_on_screen_notifier_2d_screen_exited():
	pass
	#queue_free()


func _on_hitbox_area_entered(area):
	if area is Hitbox:
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.knockback_force = knockback_force
		attack.attack_position = global_position
		attack.stun_time = stun_time
		area.damage(attack)

	queue_free()
