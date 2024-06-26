extends State

@export var player: Player

func _ready():
	player.freeze.connect(_freeze_player)

 
func _freeze_player():
	transitioned.emit(self, "playerFreeze")


func _input(_event):
	if Input.is_action_pressed("run") and player.can_run:
		transitioned.emit(self, "playerRun")
	if Input.is_action_pressed("shoot") and player.inventory.crowbar and player.current_weapon == "crowbar":
		transitioned.emit(self, "playerAttack")
	if Input.is_action_pressed("shoot") and player.inventory.blaster and player.current_weapon == "blaster":
		player.idle_timer.stop()
		transitioned.emit(self, "playerWalkShoot")


func enter():
	player.speed = player.walk_speed
	player.animation_player.play("Walk")


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
