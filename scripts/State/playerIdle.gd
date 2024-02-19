extends State

class_name PlayerIdle

@export var player : Player
@export var move_speed = 0

func _input(event):
	if Input.is_action_pressed("shoot") and player.inventory.crowbar:
		transitioned.emit(self, "playerAttack")


func enter():
	player.speed = move_speed
	player.animation_player.stop()
	
func update(delta):
	pass
		
func physics_update(_delta):
	var input_dir = player.get_input()
	player.look_at(player.get_global_mouse_position())
	player.global_rotation += PI/2
	
	if input_dir != Vector2.ZERO:
		transitioned.emit(self, "playerWalk")
