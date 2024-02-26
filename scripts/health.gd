extends Node2D

class_name Health

@export var max_health = 10

var health: float
signal game_over
signal healthChanged


func _ready():
	health = max_health


func damage(attack: Attack):
	var body = get_parent()
	if body.has_method("damage"):
		body.damage()
	health -= attack.attack_damage
	var enemy = get_parent()
	if enemy is Enemy:
		enemy.velocity = (
			(global_position - attack.attack_position).normalized() * attack.knockback_force
		)
	if health <= 0:
		var parent = get_parent()
		if parent is Player:
			game_over.emit()
			healthChanged.emit()
		else:
			parent.queue_free()
