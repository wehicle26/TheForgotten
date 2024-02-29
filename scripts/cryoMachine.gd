extends StaticBody2D


func _ready():
	SoundManager.initialize_cryo_machine_sound(self)
	SoundManager.play_cryo_machine_sound()
