extends Item

func _ready():
	interact = Callable(self, "_on_interact")
	
func _on_interact(inventory : Inventory):
	super.collect(inventory)
