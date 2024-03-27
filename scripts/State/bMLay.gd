extends State

class_name BMLay

@export var enemy: Enemy

var player: Player


func _ready():
	enemy.dead.connect(_dead)


func _dead():
	transitioned.emit(self, "BMDead")


func enter():
	player = get_tree().get_first_node_in_group("Player")
	enemy.speed = 0
	enemy.velocity = Vector2.ZERO
	
	enemy.get_node("AnimationPlayer").play("Birthing")
	await enemy.get_node("AnimationPlayer").animation_finished
	enemy.lay()
	
	transitioned.emit(self, "BMRetreat")

func physics_update(_delta):
	pass
	#var direction = player.global_position - enemy.global_position
	#enemy.look_at(direction)
	#enemy.calculate_direction("spit")
#
	#if direction.length() < enemy.attack_range:
		#transitioned.emit(self, "BMFollow")
