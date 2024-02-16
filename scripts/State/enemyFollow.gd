extends State

class_name EnemyFollow

@export var enemy : Enemy
@export var move_speed = 40
@export var attack_range = 30

var player: CharacterBody2D

func enter():
	enemy.speed = move_speed
	player = get_tree().get_first_node_in_group("Player")
	
func physics_update(_delta):
	var direction = player.global_position - enemy.global_position
	enemy.path_to_player()
	
	if direction.length() > 250 and enemy.aggro_timer.is_stopped:
		transitioned.emit(self, "idle")
	if direction.length() < attack_range:
		transitioned.emit(self, "attack")
