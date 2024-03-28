extends State


@export var enemy: Enemy

var player: Player


func enter():
	enemy.speed = enemy.default_speed
	enemy.animation_player.play("Walk")
	enemy.move_sound_timer.start()
	enemy.speed = enemy.default_speed
	player = get_tree().get_first_node_in_group("Player")


func physics_update(_delta):
	var direction = player.global_position - enemy.global_position
	#enemy.path_to_player()
	enemy.calculate_direction(false)

	if direction.length() > 250 and enemy.aggro_timer.is_stopped:
		transitioned.emit(self, "BlobIdle")
	if (direction.length() < enemy.attack_range) and enemy.is_player_spotted:
		transitioned.emit(self, "BlobAttack")
