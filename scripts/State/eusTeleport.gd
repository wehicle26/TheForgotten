extends State

class_name EusTeleport

@export var enemy: EusBoss
var glitch: CanvasLayer

func enter():
	glitch = get_tree().get_first_node_in_group("Glitch")
	glitch.visible = true
	enemy.sprite_2d.visible = false
	enemy.velocity = Vector2.ZERO
	enemy.speed = 0
	enemy.global_position = get_tree().get_nodes_in_group("EusBossSpawn").pick_random().global_position
	await get_tree().create_timer(.5).timeout
	glitch.visible = false
	enemy.sprite_2d.visible = true
	transitioned.emit(self, "eusIdle")


func update(_delta):
	pass


func physics_update(_delta):
	pass
	#if enemy.is_player_spotted:
		#transitioned.emit(self, "eusCharge")
