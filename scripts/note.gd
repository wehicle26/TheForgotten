extends Item

@onready var sprite_2d = $CanvasLayer/CenterContainer/Control/Sprite2D

var note_open = false

func _ready():
	interact = Callable(self, "_on_interact")


func _on_interact():
	if note_open:
		note_open = false
		sprite_2d.hide()
		return
	SoundManager.play_custom_sound(global_transform, "event:/note", .8)
	sprite_2d.show()
	note_open = true
