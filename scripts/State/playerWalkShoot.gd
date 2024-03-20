extends State

class_name PlayerWalkShoot

@export var player: Player

func _ready():
	player.freeze.connect(_freeze_player)


func _freeze_player():
	transitioned.emit(self, "playerFreeze")


func _input(_event):
	pass


func enter():
	player.can_shoot = true
	player.speed = player.walk_speed
	player.animation_player.play("Walk_Shoot")
	#player.gun.fire_gun()


func update(_delta):
	pass


func physics_update(_delta):
	if DialogueManager.is_dialogue_active:
		return
	var input_dir = player.get_input()
	player.look_at(player.get_global_mouse_position())
	player.global_rotation += PI / 2
	
	if input_dir == Vector2.ZERO:
		transitioned.emit(self, "playerShoot")

func _on_arm_timer_timeout():
	transitioned.emit(self, "playerWalk")
