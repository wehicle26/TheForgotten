extends State

@export var player: Player

var duration

func _ready():
	player.freeze.connect(_freeze_player)

 
func _freeze_player():
	transitioned.emit(self, "playerFreeze")


func _input(_event):
	pass


func enter():
	duration = 0.0
	player.speed = 0
	player.velocity = Vector2.ZERO
	player.animation_player.play("Crowbar_Swing_Fast")


func update(delta):
	if Input.is_action_pressed("shoot") and player.inventory.crowbar:
		duration += delta
		
	if not player.swinging:
		transitioned.emit(self, "PlayerIdle")
		#total = 0
		#transitioned.emit(self, "playerAttack")
	#if total > 0.5:


func physics_update(_delta):
	if DialogueManager.is_dialogue_active:
		transitioned.emit(self, "playerIdle")


func check_duration():
	if duration > 0.2:
		player.animation_player.play("Crowbar_Swing")
