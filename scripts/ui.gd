extends Control

var current_level: Level
var level_2: PackedScene = preload("res://scenes/Main.tscn")
var intro: PackedScene = preload("res://scenes/Intro.tscn")
@onready var background = $Background
@onready var button_container = $ButtonContainer
@onready var animation_player = $AnimationPlayer


func _ready():
	SoundManager.play_main_loop()


func _on_start_game_button_pressed():
	#current_level = intro.instantiate()
	#current_level = level_2.instantiate()
	animation_player.play("fade_out")
	await animation_player.animation_finished
	SoundManager.stop_main_loop()
	get_tree().change_scene_to_packed(intro)
	#add_child(current_level)
	background.visible = false
	button_container.visible = false


func _on_options_button_pressed():
	pass  # Replace with function body.


func _on_quit_button_pressed():
	get_tree().quit()
