extends Item


@onready var animation_player = $AnimationPlayer


func _ready():
	interact = Callable(self, "_on_interact")
	SoundManager.inittialize_bed_sound(self)


func _on_interact():
	animation_player.play("Open")

func play_bed_sound():
	SoundManager.play_bed_sound()
