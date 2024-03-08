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
	var knockback_direction = (global_position - attack.attack_position).normalized()
	body.velocity = knockback_direction * attack.knockback_force
	healthChanged.emit()
	if health <= 0:
		var parent = get_parent()
		if parent is Player:
			game_over.emit()
			
		else:
			parent.kill(knockback_direction)
