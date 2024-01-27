extends CharacterBody2D

class_name Player

@export var speed = 300
@onready var animation_player = $AnimationPlayer
@onready var gun = $Gun

@onready var ray_cast_2d = $RayCast2D
@onready var ray_cast_2d_2 = $RayCast2D2


func _ready():
	pass
	
func _input(event):
	if event.is_action_pressed("1"):
		gun.num_bullets = 1
	if event.is_action_pressed("2"):
		gun.num_bullets = 2
	if event.is_action_pressed("3"):
		gun.num_bullets = 3
	if event.is_action_pressed("4"):
		gun.num_bullets = 4
	if event.is_action_pressed("5"):
		gun.num_bullets = 5
		
	if event.is_action_pressed("shoot"):
		gun.fire_gun()
		
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
