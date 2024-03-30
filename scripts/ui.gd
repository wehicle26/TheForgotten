extends Control

var current_level: Level
var level_2: PackedScene = preload("res://scenes/Main.tscn")
var intro: PackedScene = preload("res://scenes/Intro.tscn")
var options = "res://scenes/Options.tscn"
@onready var background = $Background
@onready var button_container = $ButtonContainer
@onready var animation_player = $AnimationPlayer
@onready var texture_rect = $TextureRect

 
func _ready():
	if not GlobalState.disclaimer:
		GlobalState.disclaimer = true
		await get_tree().create_timer(7).timeout
		animation_player.play("fade_in")
	if not GlobalState.playing: 
		SoundManager.play_main_loop(SoundManager.MAIN_LOOP_INTRO)
		GlobalState.playing = true


func _on_start_game_button_pressed():
	SoundManager.play_custom_sound(null, "event:/ui_release", 0.2)
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
	SoundManager.play_custom_sound(null, "event:/ui_release", 0.2)
	get_tree().change_scene_to_file(options)


func _on_quit_button_pressed():
	SoundManager.play_custom_sound(null, "event:/ui_release", 0.2)
	get_tree().quit()


func _on_options_button_mouse_entered():
	SoundManager.play_custom_sound(null, "event:/ui_hover", 0.2)


func _on_start_game_button_mouse_entered():
	SoundManager.play_custom_sound(null, "event:/ui_hover", 0.2)


func _on_quit_button_mouse_entered():
	SoundManager.play_custom_sound(null, "event:/ui_hover", 0.2)
