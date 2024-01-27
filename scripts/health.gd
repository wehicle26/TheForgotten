extends Node2D

class_name Health

@export var max_health = 10

var health : float
signal game_over

func _ready():
	health = max_health

func damage(attack: Attack):
	health -= attack.attack_damage
	
	if health <= 0:
		var parent = get_parent()
		if parent is Player:
			game_over.emit()
		else:
			parent.queue_free()
