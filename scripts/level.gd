extends Node2D

class_name Level

enum {PROLOGUE, LEVEL_1}
@onready var player_spawn_location = $PlayerSpawnLocation
@onready var entities = $Entities
@onready var animation_player = $AnimationPlayer

var PlayerScene : PackedScene = preload("res://scenes/Player.tscn")
var player : Player

func _ready():
	#cutscene_player.play("Intro")
	#await cutscene_player.animation_finished
	Input.set_custom_mouse_cursor(null)
	player = PlayerScene.instantiate()
	#player.visible = false
	player.global_position = player_spawn_location.global_position
	entities.add_child(player)
	
	animation_player.play("fade_in")
	await animation_player.animation_finished
