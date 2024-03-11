extends Node2D

class_name Level

enum { PROLOGUE, LEVEL_1 }
@onready var player_spawn_location = $PlayerSpawnLocation
@onready var entities = $Entities
@onready var animation_player = $AnimationPlayer

var PlayerScene: PackedScene = preload("res://scenes/Player.tscn")
var player: Player


func _ready():
	SoundManager.play_main_loop(SoundManager.MAIN_LOOP_CURIOUS)
	#s.play("Intro")
	#await cutscene_player.animation_finished
	get_tree().call_group("Light", "turn_off")
	get_tree().call_group("Hallway_Light", "turn_off")
	get_tree().call_group("Cryo_Light", "turn_on")
	Input.set_custom_mouse_cursor(null)
	player = PlayerScene.instantiate()
	#player.visible = false
	player.global_position = player_spawn_location.global_position
	entities.add_child(player)

	animation_player.play("fade_in")
	await animation_player.animation_finished
s

func _on_exit_cryo_body_exited(body):
	if body is Player:
		SoundManager.set_main_loop_parameter(SoundManager.MAIN_LOOP_EERIE)
		get_tree().call_group("Cryo_Light", "turn_off")
		get_tree().call_group("Trick_Light", "turn_on")
		SoundManager.set_footstep_parameter("event:/footsteps_hallway")
		if GlobalState.encounter1:
			get_tree().call_group("Hallway_Light", "turn_on")


func _on_enter_cryo_body_exited(body):
	if body is Player:
		SoundManager.set_main_loop_parameter(SoundManager.MAIN_LOOP_CURIOUS)
		get_tree().call_group("Cryo_Light", "turn_on")
		get_tree().call_group("Hallway_Light", "turn_off")
		SoundManager.set_footstep_parameter("event:/footsteps")


func _on_enter_cargo_body_exited(body):
	if body is Player:
		#if GlobalState.encounter2:
			#SoundManager.set_main_loop_parameter(SoundManager.MAIN_LOOP_DRONE)
		#else:
			#SoundManager.stop_main_loop()
		SoundManager.set_main_loop_parameter(SoundManager.MAIN_LOOP_DRONE)
		get_tree().call_group("Cargo_Light", "turn_on")
		get_tree().call_group("Hallway_Light", "turn_off")
		SoundManager.set_footstep_parameter("event:/footsteps_cargo")


func _on_exit_cargo_body_exited(body):
	if body is Player:
		SoundManager.set_main_loop_parameter(SoundManager.MAIN_LOOP_CURIOUS)
		get_tree().call_group("Cargo_Light", "turn_off")
		get_tree().call_group("Hallway_Light", "turn_on")
		SoundManager.set_footstep_parameter("event:/footsteps_hallway")


func _on_exit_shaft_body_exited(body):
	if body is Player:
		SoundManager.set_main_loop_parameter(SoundManager.MAIN_LOOP_CURIOUS)
		get_tree().call_group("Cargo_Light", "turn_on")
		SoundManager.set_footstep_parameter("event:/footsteps_cargo")


func _on_enter_shaft_body_exited(body):
	if body is Player:
		SoundManager.set_main_loop_parameter(SoundManager.MAIN_LOOP_GARBLED)
		get_tree().call_group("Cargo_Light", "turn_off")
		SoundManager.set_footstep_parameter("event:/footsteps_metal")


func _on_exit_medical_body_exited(body):
	if body is Player:
		SoundManager.set_main_loop_parameter(SoundManager.MAIN_LOOP_GARBLED)
		SoundManager.set_footstep_parameter("event:/footsteps_metal")


func _on_enter_medical_body_exited(body):
	if body is Player:
		SoundManager.set_main_loop_parameter(SoundManager.MAIN_LOOP_GARBLED)
		SoundManager.set_footstep_parameter("event:/footsteps_medical")
