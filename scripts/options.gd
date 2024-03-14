extends Control

var current_level: Level
var ui = "res://scenes/Ui.tscn"

var playing = false
@onready var background = $Background
@onready var button_container = $ButtonContainer


func _ready():
	pass


func _on_back_button_pressed():
	SoundManager.play_custom_sound(null, "event:/ui_release", 0.2)
	get_tree().change_scene_to_file(ui)


func _on_back_button_mouse_entered():
	SoundManager.play_custom_sound(null, "event:/ui_hover", 0.2)
