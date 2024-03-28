extends State

class_name BMIdle

@export var enemy: Enemy

var player: Player
var move_direction: Vector2
var wander_time: float
@onready var line_of_sight = $"../../LineOfSight"

func _ready():
	enemy.dead.connect(_dead)


func _dead():
	transitioned.emit(self, "BMDead")


func enter():
	player = get_tree().get_first_node_in_group("Player")
	enemy.speed = 25
	randomize_wander()
	#transitioned.emit(self, "BMRetreat")

func physics_update(_delta):
	player = get_tree().get_first_node_in_group("Player")
	var direction = player.global_position - enemy.global_position
	enemy.calculate_direction("idle")
#
	if direction.length() < enemy.attack_range and enemy.is_player_spotted:
		transitioned.emit(self, "BMFollow")


func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)


func update(delta):
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()
