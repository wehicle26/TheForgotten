extends Item

class_name Crew


func _ready():
	interact = Callable(self, "_on_interact")


func _on_interact():
	animation_player.play("Open")
