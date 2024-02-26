extends Crew

@onready var ray_cast_2d = $RayCast2D
@onready var canvas_layer = $CanvasLayer
@onready var light = $Light
@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer


var darkness: CanvasModulate
var played = false

func _ready():
	SoundManager.initialize_eus_sound(self)
	darkness = get_tree().get_first_node_in_group("Darkness")


func _process(_delta):
	if ray_cast_2d.is_colliding() and not played:
		if ray_cast_2d.get_collider() is Player:
			played = true
			animation_player.play("eus")
			await animation_player.animation_finished
			get_tree().call_group("Light", "turn_on")
			light.visible = false
			darkness.color = Color(0.035, 0.039, 0.078)


func play_eus_sound():
	get_tree().call_group("Light", "turn_off")
	darkness.color = Color(0, 0, 0)
	SoundManager.play_eus_sound()
