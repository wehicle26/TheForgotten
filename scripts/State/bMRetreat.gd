extends State

class_name BMRetreat

@export var enemy: Enemy

var player: Player
var direction

func enter():
	player = get_tree().get_first_node_in_group("Player")
	enemy.speed = enemy.default_speed
	
	enemy.get_node("AnimationPlayer").play("Skitter")
	if not enemy.berserk:
		await get_tree().create_timer(randf_range(1, 3)).timeout
	else:
		await get_tree().create_timer(randf_range(0.5, 1)).timeout

	var next_state: String = enemy.get_next_attack()
	transitioned.emit(self, next_state)

func physics_update(_delta):
	enemy.calculate_direction("retreat")
	if is_instance_valid(player):
		direction = player.global_position - enemy.global_position
	#enemy.look_at(direction)
#
		if direction.length() > enemy.attack_range:
			transitioned.emit(self, "BMFollow")
