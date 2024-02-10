extends CharacterBody2D

class_name Player

@export var speed = 85
@onready var animation_player = $AnimationPlayer
@onready var gun = $Gun
@onready var flashlight = $Flashlight
@onready var sprite_2d = $PlayerSprite

var knockback = Vector2.ZERO


func _ready():
	gun.get_node("ArmTimer").timeout.connect(_lower_arm)
	sprite_2d.material.set_shader_parameter("active", false) 

func damage():
	print("tint")
	sprite_2d.material.set_shader_parameter("active", true)
	var timer = get_tree().create_timer(.5)
	await timer.timeout
	sprite_2d.material.set_shader_parameter("active", false)
	
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
	
	if event.is_action_pressed("flashlight_toggle"):
		flashlight.toggle()
		
func get_input():
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_dir * speed + knockback
	
	if Input.is_action_pressed("shoot"):
		gun.fire_gun()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	get_input()
	move_and_slide()
	look_at(get_global_mouse_position())
	global_rotation += PI/2
#	var vector = global_position - get_global_mouse_position()
#	var angle = vector.angle()
#	var rotaion = global_rotation
#	global_rotation= lerp(rotaion, angle, 0.2)
	
	if velocity != Vector2(0, 0):
		#animation_player.play("shoot")
		pass
	else:
		pass
		#animation_player.stop()

func _lower_arm():
	animation_player.play("RESET")


func _on_hitbox_body_entered(body):
	if body is Enemy:
		print(body)
