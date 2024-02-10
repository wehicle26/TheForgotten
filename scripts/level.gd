extends Node2D

class_name Level

enum {PROLOGUE, LEVEL_1}
@onready var player_spawn_location = $PlayerSpawnLocation
@onready var entities = $Entities

var PlayerScene : PackedScene = preload("res://scenes/Player.tscn")
var player : Player

func _ready():
	player = PlayerScene.instantiate()
	player.global_position = player_spawn_location.global_position
	entities.add_child(player)
