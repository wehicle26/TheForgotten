extends Control

enum {MAIN_LOOP_INTRO, MAIN_LOOP_CURIOUS, MAIN_LOOP_EERIE, MAIN_LOOP_DRONE, MAIN_LOOP_GARBLED}
var event: FmodEvent = null
var current_level : Level
var level_2 : PackedScene = preload("res://scenes/Main.tscn")
@onready var background = $Background
@onready var button_container = $ButtonContainer

func _ready():
	initialize_fmod()


func _on_start_game_button_pressed():
	current_level = level_2.instantiate()
	add_child(current_level)
	background.visible = false
	button_container.visible = false


func _on_options_button_pressed():
	pass # Replace with function body.


func _on_quit_button_pressed():
	get_tree().quit()


func initialize_fmod():
	FmodServer.add_listener(0, self)
	FmodServer.load_bank("res://sounds/banks/Desktop/Master.strings.bank", 
	FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL)
	FmodServer.load_bank("res://sounds/banks/Desktop/Master.bank", 
	FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL)
	FmodServer.load_bank("res://sounds/banks/Desktop/MainLoop.bank", 
	FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL)

	event = FmodServer.create_event_instance("event:/the_forgotten2.rpp")
	event.set_volume(1)
	event.start()
	FmodServer.set_global_parameter_by_name("mainLoopLevel", MAIN_LOOP_CURIOUS)
