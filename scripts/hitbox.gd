extends Area2D

class_name Hitbox

@export var health : Health

func damage(attack: Attack):
	if health:
		health.damage(attack)
