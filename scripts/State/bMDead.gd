extends State

class_name BMDead

@export var enemy: Enemy

func enter():
	enemy.speed = 0
	enemy.velocity = Vector2.ZERO
	enemy.animation_player.play("Death")

