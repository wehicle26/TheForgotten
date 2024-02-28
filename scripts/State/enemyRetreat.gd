extends State

class_name EnemyRetreat

@export var enemy: Enemy

var player: Player


func enter():
	player = get_tree().get_first_node_in_group("Player")
	await get_tree().create_timer(randf_range(1, 3)).timeout
	
	transitioned.emit(self, "follow")

func physics_update(_delta):
	var direction = player.global_position - enemy.global_position
	#enemy.look_at(direction)
	enemy.retreat_from_player()
#
	#if direction.length() > attack_range:
		#transitioned.emit(self, "follow")
