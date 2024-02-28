extends State


@export var player: Player


func _ready():
	player.unfreeze.connect(_unfreeze_player)

 
func _unfreeze_player():
	transitioned.emit(self, "playerIdle")


func enter():
	player.speed = 0
	player.velocity = Vector2.ZERO
	player.animation_player.play("RESET")


func update(_delta):
	pass


func physics_update(_delta):
	player.look_at(player.get_global_mouse_position())
	player.global_rotation += PI / 2
