extends State

class_name EnemyRetreat

@export var enemy: Enemy

var player: Player


func enter():
	player = get_tree().get_first_node_in_group("Player")
	enemy.speed = 25
	await get_tree().create_timer(randf_range(1, 3)).timeout
	
	transitioned.emit(self, "spiderFollow")

func physics_update(_delta):
	var _direction = player.global_position - enemy.global_position
	#enemy.look_at(direction)
	enemy.calculate_direction(true)
#
	#if direction.length() > attack_range:
		#transitioned.emit(self, "follow")
