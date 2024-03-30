extends Item

@export var note_texture: Texture2D
@onready var sprite_2d = $CanvasLayer/CenterContainer/Control/Sprite2D

var note_open = false

func _ready():
	interact = Callable(self, "_on_interact")
	sprite_2d.texture = note_texture


func _on_interact():
	if note_open:
		note_open = false
		sprite_2d.hide()
		SoundManager.play_custom_sound(global_transform, "event:/note_close", .8)
		player.unfreeze_player()
		return
	SoundManager.play_custom_sound(global_transform, "event:/note", .8)
	sprite_2d.show()
	note_open = true
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("Player")
	player.freeze_player()
