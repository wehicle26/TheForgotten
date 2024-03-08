extends State

class_name EusIdle

@export var enemy: EusBoss


func enter():
	enemy.velocity = Vector2.ZERO
	enemy.speed = enemy.default_speed


func update(delta):
	pass


func physics_update(_delta):
	if enemy.is_player_spotted and not enemy.has_crashed:
		transitioned.emit(self, "eusCharge")
