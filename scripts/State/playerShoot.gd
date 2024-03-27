extends State

class_name PlayerShoot

@export var player: Player

func _ready():
	player.freeze.connect(_freeze_player)


func _freeze_player():
	transitioned.emit(self, "playerFreeze")


func _input(_event):
	pass


func enter():
	player.can_shoot = true
	player.speed = 0
	player.animation_player.play("Shoot")
	#player.gun.fire_gun()


func update(_delta):
	pass


func physics_update(_delta):
	if DialogueManager.is_dialogue_active:
		return

	var input_dir = player.get_input()
	player.look_at(player.get_global_mouse_position())
	player.global_rotation += PI / 2

	if input_dir != Vector2.ZERO:
		transitioned.emit(self, "playerWalkShoot")
	
	if input_dir != Vector2.ZERO:
		if player.current_weapon == "crowbar":
			transitioned.emit(self, "playerWalk")

		transitioned.emit(self, "playerWalkShoot")
	
	if player.current_weapon == "crowbar":
		transitioned.emit(self, "playerIdle")


func _on_arm_timer_timeout():
	transitioned.emit(self, "playerWalk")
