extends Node2D

class_name Level

enum { PROLOGUE, LEVEL_1 }
@onready var player_spawn_location = $PlayerSpawnLocation
@onready var entities = $Entities
@onready var animation_player = $AnimationPlayer
@onready var space = $Space
@onready var grain = $Grain
@onready var overlay = $Overlay
@onready var pause_menu = $PauseMenu
@onready var blob_spawn_location = $BlobSpawnLocation
@onready var spider_spawn_location = $SpiderSpawnLocation
@onready var spider_spawn_location_2 = $SpiderSpawnLocation2


var PlayerScene: PackedScene = preload("res://scenes/Player.tscn")
var blobScene: PackedScene = preload("res://scenes/Blob.tscn")
var spiderScene: PackedScene = preload("res://scenes/Spider.tscn")
var player: Player
var paused = false
var combat = false
var enemy_count = 0

func _process(_delta):
	pass


func _input(event):
	if event.is_action_pressed("pause"):
		if not paused:
			paused = true
			pause()


func pause():
	pause_menu.show()
	get_tree().paused = true
	SoundManager.pause()

func _unpause():
	await get_tree().create_timer(.2).timeout
	paused = false
	
func _ready():
	pause_menu.unpaused.connect(_unpause)
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
	animation_player.get_node("CanvasLayer").visible = true
	animation_player.play("fade_in")
	await animation_player.animation_finished
	if not GlobalState.dialogue1:
		GlobalState.dialogue1 = true
		DialogueManager.start_passive_dialogue(player.global_position, ["Where is everyone?"])

func _on_exit_cryo_body_exited(body):
	if body is Player:
		SoundManager.set_main_loop_parameter(SoundManager.MAIN_LOOP_EERIE)
		get_tree().call_group("Cryo_Light", "turn_off")
		#get_tree().call_group("Trick_Light", "turn_on")
		SoundManager.set_footstep_parameter("event:/footsteps_hallway")
		get_tree().call_group("Hallway_Light", "turn_on")
		
		if not GlobalState.dialogue2:
			GlobalState.dialogue2 = true
			await get_tree().create_timer(.5).timeout
			DialogueManager.start_passive_dialogue(player.global_position, ["Hello...?"])


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
		if not GlobalState.dialogue3:
			GlobalState.dialogue3 = true
			await get_tree().create_timer(.5).timeout
			DialogueManager.start_passive_dialogue(player.global_position, ["Why is it so dark in here?"])


func _on_exit_cargo_body_exited(body):
	if body is Player:
		SoundManager.set_main_loop_parameter(SoundManager.MAIN_LOOP_CURIOUS)
		get_tree().call_group("Cargo_Light", "turn_off")
		get_tree().call_group("Hallway_Light", "turn_on")
		SoundManager.set_footstep_parameter("event:/footsteps_hallway")


func _on_drop_pods_body_exited(body):
	if body is Player:
		if not GlobalState.dialogue4:
				GlobalState.dialogue4 = true
				DialogueManager.start_passive_dialogue(player.global_position, ["A single functional escape pod..."])
				SoundManager.set_main_loop_parameter(SoundManager.COMBAT_LOW)


func _on_event_2_body_exited(body):
	if body is Player:
		if not GlobalState.encounter2:
			GlobalState.encounter2 = true
			SoundManager.play_custom_sound(null, "event:/stinger2", 0.9)
			var spider1 = spiderScene.instantiate()
			entities.call_deferred("add_child", spider1)
			#entities.add_child(spider)
			spider1.global_position = spider_spawn_location.global_position
			spider1.spider_dead.connect(_check_enemy_count)
			var spider2 = spiderScene.instantiate()
			entities.call_deferred("add_child", spider2)
			#entities.add_child(spider)
			spider2.global_position = spider_spawn_location_2.global_position
			spider2.spider_dead.connect(_check_enemy_count)
			SoundManager.set_main_loop_parameter(SoundManager.COMBAT_MID)
			combat = true
			enemy_count = 2


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


func _check_enemy_count():
	enemy_count -= 1
	if enemy_count == 0:
		combat = false
		SoundManager.set_main_loop_parameter(SoundManager.MAIN_LOOP_GARBLED)


func _on_exit_medical_body_exited(body):
	if body is Player:
		SoundManager.set_main_loop_parameter(SoundManager.MAIN_LOOP_GARBLED)
		SoundManager.set_footstep_parameter("event:/footsteps_metal")


func _on_enter_medical_body_exited(body):
	if body is Player:
		SoundManager.set_main_loop_parameter(SoundManager.MAIN_LOOP_GARBLED)
		SoundManager.set_footstep_parameter("event:/footsteps_medical")
		if not GlobalState.encounter4:
			GlobalState.encounter4 = true
			var blob = blobScene.instantiate()
			entities.call_deferred("add_child", blob)
			blob.global_position = blob_spawn_location.global_position
			enemy_count += 2
			SoundManager.set_main_loop_parameter(SoundManager.COMBAT_MID_HIGH)
			combat = true


func _on_event_1_body_exited(body):
	if body is Player and not GlobalState.encounter1:
		GlobalState.encounter1 = true
		player.walk_speed = 20
		player.can_run = false
		player.freeze_player()
		get_tree().call_group("Hallway_Light", "turn_off")
		await get_tree().create_timer(0.2).timeout
		get_tree().call_group("Hallway_Light", "turn_on")
		player.unfreeze_player()
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
		var lines: Array[String] = ["Huh...?",]
		DialogueManager.start_passive_dialogue(player.global_position, lines)
		player.walk_speed = 45
		#player.can_run = true

func _on_enter_bathroom_body_exited(body):
	if body is Player:
		SoundManager.stop_main_loop()
		SoundManager.set_footstep_parameter("event:/footsteps_bathroom", .7)


func _on_exit_bathroom_body_exited(body):
	if body is Player:
		SoundManager.set_footstep_parameter("event:/footsteps_hallway")


func _on_event_5_body_exited(body):
	if body is Player:
		get_tree().call_group("Trick_Light", "turn_on")

