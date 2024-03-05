extends Enemy


func kill(_splat_direction):
	pass


func damage():
	pass


func _ready():
	pass


func play_enemy_move_sound():
	SoundManager.play_enemy_move_sound(self)
