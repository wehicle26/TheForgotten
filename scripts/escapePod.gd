extends Item


func _ready():
	interact = Callable(self, "_on_interact")


func _on_interact():
	player = get_tree().get_first_node_in_group("Player")
	DialogueManager.start_dialogue(player.global_position, ["Access Denied? I guess I can't leave..."])
