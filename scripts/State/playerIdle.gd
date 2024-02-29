extends State

@export var player: Player
var idle_array = ["Idle1", "Idle2", "Idle3"]

func _ready():
	player.freeze.connect(_freeze_player)

 
func _freeze_player():
	transitioned.emit(self, "playerFreeze")


func _input(_event):
	if Input.is_action_pressed("shoot") and player.inventory.crowbar:
		player.idle_timer.stop()
		transitioned.emit(self, "playerAttack")


func enter():
	player.speed = 0
	player.animation_player.play("RESET")
	player.idle_timer.start(randf_range(5, 10))


func update(_delta):
	pass


func physics_update(_delta):
	if DialogueManager.is_dialogue_active:
		return
	var input_dir = player.get_input()
	player.look_at(player.get_global_mouse_position())
	player.global_rotation += PI / 2

	if input_dir != Vector2.ZERO:
		player.idle_timer.stop()
		transitioned.emit(self, "playerWalk")


func _on_idle_timer_timeout():
	player.idle_timer.start(randf_range(5, 10))
	player.animation_player.play(idle_array.pick_random())
