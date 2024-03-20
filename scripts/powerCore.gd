extends Item

@onready var animation_player = $AnimationPlayer
@onready var light_occluder_2d = $LightOccluder2D
@onready var light_occluder_2d_2 = $LightOccluder2D2

@export var broken = false

func _ready():
	interact = Callable(self, "_on_interact")
	if not broken:
		animation_player.play("Cycle")
		SoundManager.play_custom_sound(global_transform, "event:/power_core", .5)
		light_occluder_2d.queue_free()
	else:
		light_occluder_2d.queue_free()
		animation_player.play("Broken")


func _on_interact():
	player = get_tree().get_first_node_in_group("Player")
	if not broken:
		DialogueManager.start_passive_dialogue(player.global_position, ["Thank God this power core is still working."])
	else:
		DialogueManager.start_passive_dialogue(player.global_position, ["Why is this core missing a component?"])
		
