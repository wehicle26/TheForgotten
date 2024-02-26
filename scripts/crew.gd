extends Item

class_name Crew

var lines: Array[String] = []


func _ready():
	interact = Callable(self, "_on_interact")
	SoundManager.inittialize_speech_sound(self)


func _on_interact():
	DialogueManager.start_dialogue(global_position, lines)
	await DialogueManager.dialogue_finished
