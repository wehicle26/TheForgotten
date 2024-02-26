extends Crew

class_name InsaneCrew

@onready var animation_player = $AnimationPlayer
@onready var collision_shape_2d = $CollisionShape2D

@export var darkness : CanvasModulate

func _ready():
	lines = [
	"Not.. safe.. here...",
	"Everyone... dead...",
	"Can't... take this...",
	"It's too late... for me...",
	"Need... to get... away...",
	"Need to get out."
	]
	
	darkness = get_tree().get_first_node_in_group("Darkness")

	interact = Callable(self, "_on_interact")
	SoundManager.inittialize_speech_sound(self)


func _on_interact():
	DialogueManager.start_dialogue(global_position, lines)
	await DialogueManager.dialogue_finished
	interact = func():
		pass
	#darkness.color = Color(0, 0, 0)
	collision_shape_2d.disabled = true
	animation_player.play("Deadge")
	SoundManager.play_custom_sound(self.global_transform, "event:/deadge", .6)


func fade_in():
	pass
	#var tween = get_tree().create_tween()
	#tween.tween_property(darkness, "color", Color(0.035, 0.039, 0.078), 0.5).set_trans(Tween.TRANS_LINEAR)
