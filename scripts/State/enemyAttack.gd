extends State

class_name EnemyAttack

@export var enemy : Enemy
@export var lunge_speed = 50
@export var attack_range = 30
@export var knockback_force = 30
@export var stun_time = 0.3

var player: CharacterBody2D

func enter():
	player = get_tree().get_first_node_in_group("Player")
	print("attack")
	
func physics_update(_delta):
	var direction = player.global_position - enemy.global_position
	#enemy.velocity = lunge_speed * -direction

	if direction.length() > attack_range:
		transitioned.emit(self, "follow")
