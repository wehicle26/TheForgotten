extends Node2D

var spider_scene: PackedScene = preload("res://scenes/Spider.tscn")
@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("Squish")
	SoundManager.play_custom_sound(global_transform, "event:/egg_crack", .9)
	await animation_player.animation_finished
	var spider = spider_scene.instantiate()
	spider.global_position = global_position
	var entities = get_tree().get_first_node_in_group("Entities")
	entities.add_child(spider)
