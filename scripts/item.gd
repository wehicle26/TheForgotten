extends Area2D

class_name Item

@export var itemRes : InventoryItem
@export var action_name : String = "interact"

@onready var player : Player = get_tree().get_first_node_in_group("Player")

var interact: Callable = func():
	pass


func collect(inventory: Inventory):
	inventory.insert(itemRes)
	queue_free()


func _on_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("interact"):
		pass


func _on_body_entered(body):
	InteractionManager.register_area(self)


func _on_body_exited(body):
	InteractionManager.unregister_area(self)
