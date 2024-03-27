extends Item

@onready var animation_player = $AnimationPlayer
@export var open: bool
@export var smashed: bool

func _ready():
	if smashed:
		animation_player.play("Smashed")
		return
	interact = Callable(self, "_on_interact")
	SoundManager.inittialize_bed_sound(self)


func _on_interact():
	if not open:
		animation_player.play("Open")


func play_bed_sound():
	SoundManager.play_bed_sound()
	open = true
