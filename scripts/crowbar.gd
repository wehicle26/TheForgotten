extends Item


func _ready():
	interact = Callable(self, "_on_interact")


func _on_interact(inventory: Inventory):
	super.collect(inventory)
	player = get_tree().get_first_node_in_group("Player")
	player.show_tut("crowbar")
