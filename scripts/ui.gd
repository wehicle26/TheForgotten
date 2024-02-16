extends Control


var current_level : Level
var level_2 : PackedScene = preload("res://scenes/Main.tscn")
@onready var background = $Background
@onready var button_container = $ButtonContainer

func _ready():
	pass


func _on_start_game_button_pressed():
	current_level = level_2.instantiate()
	add_child(current_level)
	background.visible = false
	button_container.visible = false


func _on_options_button_pressed():
	pass # Replace with function body.


func _on_quit_button_pressed():
	get_tree().quit()

