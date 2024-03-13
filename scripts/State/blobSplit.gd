extends State


@export var enemy: Enemy

var player: Player

func _ready():
	pass


func enter():
	player = get_tree().get_first_node_in_group("Player")
	enemy.speed = 0
	enemy.velocity = Vector2.ZERO
	enemy.split_blob()
	
	transitioned.emit(self, "blobFollow")

func physics_update(_delta):
	pass
	#var _direction = player.global_position - enemy.global_position
	#enemy.look_at(direction)
	#enemy.retreat_from_player()
#
	#if direction.length() > attack_range:
		#transitioned.emit(self, "follow")
