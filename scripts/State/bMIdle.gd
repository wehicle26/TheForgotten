extends State

class_name BMIdle

@export var enemy: Enemy

var player: Player
var move_direction: Vector2
var wander_time: float

func enter():
	player = get_tree().get_first_node_in_group("Player")
	enemy.speed = 25
	randomize_wander()
	#transitioned.emit(self, "BMRetreat")

func physics_update(_delta):
	pass
	#var _direction = player.global_position - enemy.global_position
	#enemy.look_at(direction)
	#enemy.calculate_direction(true)
#
	#if direction.length() > attack_range:
		#transitioned.emit(self, "follow")


func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)


func update(delta):
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()
