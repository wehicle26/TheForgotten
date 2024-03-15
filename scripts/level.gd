extends Node2D

class_name Level

enum { PROLOGUE, LEVEL_1 }
@onready var player_spawn_location = $PlayerSpawnLocation
@onready var entities = $Entities
@onready var animation_player = $AnimationPlayer
@onready var space = $Space
@onready var grain = $Grain
@onready var overlay = $Overlay
@onready var blob_spawn_location = $BlobSpawnLocation


var PlayerScene: PackedScene = preload("res://scenes/Player.tscn")
var blobScene: PackedScene = preload("res://scenes/Blob.tscn")
var player: Player


func _ready():
	space.visible = true
	grain.visible = true
	overlay.visible = true
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

func _on_exit_cryo_body_exited(body):
	if body is Player:
		SoundManager.set_main_loop_parameter(SoundManager.MAIN_LOOP_EERIE)
		get_tree().call_group("Cryo_Light", "turn_off")
		#get_tree().call_group("Trick_Light", "turn_on")
		SoundManager.set_footstep_parameter("event:/footsteps_hallway")
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
		if not GlobalState.encounter3:
			GlobalState.encounter3 = true
			var blob = blobScene.instantiate()
			entities.call_deferred("add_child", blob)
			blob.global_position = blob_spawn_location.global_position


func _on_event_1_body_exited(body):
	if body is Player and not GlobalState.encounter1:
		GlobalState.encounter1 = true
		get_tree().call_group("Hallway_Light", "turn_off")
		await get_tree().create_timer(0.2).timeout
		get_tree().call_group("Hallway_Light", "turn_on")
		SoundManager.stop_main_loop()
		SoundManager.play_custom_sound(player.global_transform, "event:/stinger1", 0.9)
		var glitch: CanvasLayer = get_tree().get_first_node_in_group("Glitch")
		glitch.visible = true
		get_tree().call_group("goo", "show_goo")
		await get_tree().create_timer(5).timeout
		glitch.visible = false
		get_tree().call_group("goo", "hide_goo")
		get_tree().call_group("Hallway_Light", "turn_off")
		await get_tree().create_timer(0.2).timeout
		get_tree().call_group("Hallway_Light", "turn_on")
		SoundManager.play_main_loop(SoundManager.MAIN_LOOP_CURIOUS)
