extends State

class_name PlayerAttack

@export var player : Player
@export var move_speed = 0

func _input(event):
	pass


func enter():
	player.speed = move_speed
	player.velocity = Vector2.ZERO
	player.animation_player.play("Crowbar_Swing")


func update(delta):
	pass



func physics_update(_delta):
	#player.look_at(player.get_global_mouse_position())
	#player.global_rotation += PI/2
	
	if not player.swinging:
		transitioned.emit(self, "PlayerIdle")
	
	
