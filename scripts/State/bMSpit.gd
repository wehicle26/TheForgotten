extends State

class_name BMSpit


@export var enemy: Enemy

var player: Player


func enter():
	player = get_tree().get_first_node_in_group("Player")
	enemy.speed = 0
	enemy.velocity = Vector2.ZERO
	
	enemy.get_node("AnimationPlayer").play("Fly")
	await get_tree().create_timer(randf_range(1, 3)).timeout
	enemy.get_node("AnimationPlayer").play("Spit")
	enemy.spit()
	await enemy.get_node("AnimationPlayer").animation_finished
	
	transitioned.emit(self, "BMRetreat")

func physics_update(_delta):
	pass
	#var direction = player.global_position - enemy.global_position
	#enemy.look_at(direction)
	enemy.calculate_direction("spit")
#
	#if direction.length() < enemy.attack_range:
		#transitioned.emit(self, "BMFollow")
