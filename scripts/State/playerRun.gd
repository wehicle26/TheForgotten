extends State

class_name PlayerRun

@export var player: Player
@export var move_speed = 85


func _input(_event):
	if Input.is_action_just_released("run"):
		transitioned.emit(self, "playerWalk")


func enter():
	player.speed = move_speed
	player.animation_player.play("Run")


func update(_delta):
	pass


func physics_update(_delta):
	if DialogueManager.is_dialogue_active:
		transitioned.emit(self, "playerIdle")
	var input_dir = player.get_input()
	player.look_at(player.get_global_mouse_position())
	player.global_rotation += PI / 2

	if input_dir == Vector2.ZERO:
		transitioned.emit(self, "playerIdle")
