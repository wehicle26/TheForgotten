extends State

class_name EnemyAttack

@export var enemy : CharacterBody2D
@export var lunge_speed = 50
@export var attack_range = 30

var player: CharacterBody2D

func enter():
	player = get_tree().get_first_node_in_group("Player")
	print("attack")
	#var direction = player.global_position - enemy.global_position
	
func physics_update(delta):
	var direction = player.global_position - enemy.global_position
	#enemy.velocity = lunge_speed * -direction
	if direction.length() > attack_range:
		transitioned.emit(self, "follow")
