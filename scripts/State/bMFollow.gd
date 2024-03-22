extends State

class_name BMFollow

@export var enemy: Enemy

var player: Player


func enter():
	enemy.animation_player.play("Skitter")
	enemy.move_sound_timer.start()
	enemy.speed = enemy.default_speed
	player = get_tree().get_first_node_in_group("Player")
	await get_tree().create_timer(randf_range(1, 3)).timeout
	#transitioned.emit(self, "BMSpit")


func physics_update(_delta):
	var direction = player.global_position - enemy.global_position
	enemy.calculate_direction("follow")

	#if direction.length() > 250 and enemy.aggro_timer.is_stopped:
		#transitioned.emit(self, "idle")
	if (direction.length() < enemy.attack_range) and enemy.is_player_spotted:
		transitioned.emit(self, "BMSpit")
