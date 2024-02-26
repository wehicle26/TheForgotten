extends State

class_name PlayerAttack

@export var player: Player
@export var move_speed = 0

var duration


func _input(_event):
	pass


func enter():
	duration = 0.0
	player.speed = move_speed
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
