extends Crew

class_name InsaneCrew

@onready var animation_player = $AnimationPlayer
@onready var collision_shape_2d = $CollisionShape2D


func _ready():
	lines = [
	"Can't... take this... anymore...",
	]

	interact = Callable(self, "_on_interact")
	SoundManager.inittialize_speech_sound(self)


func _on_interact():
	DialogueManager.start_dialogue(global_position, lines)
	await DialogueManager.dialogue_finished
	interact = func():
		pass
	collision_shape_2d.disabled = true
	SoundManager.stop_main_loop()
	animation_player.play("Deadge")
	SoundManager.play_custom_sound(self.global_transform, "event:/deadge", .6)
	await animation_player.animation_finished
	SoundManager.play_main_loop(SoundManager.MAIN_LOOP_CURIOUS)


func pitch_black():
	get_tree().call_group("Cryo_Light", "turn_off")


func restore_light():
	get_tree().call_group("Cryo_Light", "turn_on")
