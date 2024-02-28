extends Crew

@onready var canvas_layer = $CanvasLayer
@onready var light = $Light
@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var rays = $Rays
@onready var trick_item = $TrickItem
@onready var trick_light = $TrickLight

var played = false

func _ready():
	SoundManager.initialize_eus_sound(self)


func _process(_delta):
	for ray in rays.get_children():
		if ray.is_colliding() and ray.get_collider() is Player and not played:
			player = ray.get_collider()
			trick_item.visible = false
			trick_light.visible = false
			player.freeze_player()
			played = true
			animation_player.play("eus")
			await animation_player.animation_finished
			get_tree().call_group("Hallway_Light", "turn_on")
			light.visible = false
			player.unfreeze_player()
			GlobalState.encounter1 = true
			queue_free()


func play_eus_sound():
	get_tree().call_group("Light", "turn_off")
	SoundManager.play_eus_sound()
