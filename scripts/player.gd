extends CharacterBody2D

class_name Player

signal healthChanged 

@export var speed = 85
@export var inventory : Inventory
@onready var animation_player = $AnimationPlayer
@onready var gun = $Gun
@onready var flashlight = $Flashlight
@onready var sprite_2d = $Sprite2D
@onready var health = $Health
@onready var player_sprite = $PlayerSprite
@onready var feet = $Feet
@onready var player_feet = $PlayerFeet

@onready var currentHealth: int = health.max_health
@onready var max_Health: int = health.max_health
const CROSSHAIR_004 = preload("res://art/player/crosshair004.png")

var knockback = Vector2.ZERO
var footstep_sound : FmodEvent
var isPlaying = true
var emitter : FmodEventEmitter2D
var input_dir : Vector2


func _ready():
	gun.get_node("ArmTimer").timeout.connect(_lower_arm)
	#player_sprite.material.set_shader_parameter("active", false)
	footstep_sound = FmodServer.create_event_instance("event:/footsteps")
	footstep_sound.set_2d_attributes(self.global_transform)
	footstep_sound.set_volume( 1 )


func damage():
	print("tint")
	#player_sprite.material.set_shader_parameter("active", true)
	var timer = get_tree().create_timer(.5)
	await timer.timeout
	#player_sprite.material.set_shader_parameter("active", false)

func play_footstep():
	footstep_sound.start()

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
	input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_dir * speed + knockback
	
	if Input.is_action_pressed("shoot"):
		gun.fire_gun()

func _process(_delta):
	pass
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_input()
	move_and_slide()
	look_at(get_global_mouse_position())
	global_rotation += PI/2
#	var vector = global_position - get_global_mouse_position()
#	var angle = vector.angle()
#	var rotaion = global_rotation
#	global_rotation= lerp(rotaion, angle, 0.2)
	
	if velocity != Vector2(0, 0):
		#animation_player.play("Walk")
		if not gun.get_node("ArmTimer").is_stopped():
			animation_player.play("Walk_Shoot")
		else:
			animation_player.play("Walk")
		
	else:
		animation_player.stop()

func _lower_arm():
	animation_player.play("Walk")


func _on_hitbox_body_entered(body):
	if body is Enemy:
		print(body)
