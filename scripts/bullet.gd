extends RigidBody2D

class_name Bullet

@export var bullet_speed = 500.
@onready var gpu_particles_2d = $GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var velocity = Vector2(bullet_speed, 0.0)
	global_rotation -= PI / 2
	set_linear_velocity(velocity.rotated(global_rotation))


func _on_visible_on_screen_notifier_2d_screen_exited():
	pass
	#queue_free()
