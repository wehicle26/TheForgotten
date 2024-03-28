extends Node

enum { MAIN_LOOP_INTRO, MAIN_LOOP_CURIOUS, MAIN_LOOP_EERIE, MAIN_LOOP_DRONE, MAIN_LOOP_GARBLED,
COMBAT_LOW, COMBAT_MID, COMBAT_MID_HIGH, COMBAT_HIGH }
enum { PAUSED, RUNNING}
var event: FmodEvent = null
var game_state: FmodEvent
var intro_sound: FmodEvent
var footstep_sound: FmodEvent
var crowbar_swing_sound: FmodEvent
var crowbar_swing_fast_sound: FmodEvent
var roach_move_sound: FmodEvent
var bed_sound: FmodEvent
var let_me_out_sound: FmodEvent
var shatter_glass_sound: FmodEvent
var speech_sound: FmodEvent
var cryo_machine_sound: FmodEvent
var eus_sound: FmodEvent
var heartbeat_sound: FmodEvent


func _ready():
	initialize_fmod()
	initialize_sounds()


func initialize_fmod():
	#FmodServer.add_listener(0, self)
	FmodServer.load_bank(
		"res://sounds/banks/Desktop/Master.strings.bank", FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL
	)
	FmodServer.load_bank(
		"res://sounds/banks/Desktop/Master.bank", FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL
	)
	FmodServer.load_bank(
		"res://sounds/banks/Desktop/MainLoop.bank", FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL
	)
	FmodServer.load_bank(
		"res://sounds/banks/Desktop/Sounds.bank", FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL
	)
	game_state = FmodServer.create_event_instance("event:/game_status")
	game_state.start()


func set_main_loop_parameter(loopLevel):
	FmodServer.set_global_parameter_by_name("mainLoopLevel", loopLevel)


func set_footstep_parameter(event_name, volume: float = .4):
	footstep_sound = FmodServer.create_event_instance(event_name)
	footstep_sound.set_volume(volume)


func initialize_player_sounds(player: Player):
	FmodServer.add_listener(0, player)
	footstep_sound = FmodServer.create_event_instance("event:/footsteps")
	footstep_sound.set_2d_attributes(player.global_transform)
	footstep_sound.set_volume(.4)

	crowbar_swing_sound = FmodServer.create_event_instance("event:/crowbar_swing")
	crowbar_swing_sound.set_2d_attributes(player.global_transform)
	crowbar_swing_sound.set_volume(.5)
	
	crowbar_swing_fast_sound = FmodServer.create_event_instance("event:/crowbar_swing_fast")
	crowbar_swing_fast_sound.set_2d_attributes(player.global_transform)
	crowbar_swing_fast_sound.set_volume(.5)
	
	heartbeat_sound = FmodServer.create_event_instance("event:/heartbeat")
	heartbeat_sound.set_2d_attributes(player.global_transform)
	heartbeat_sound.set_volume(.9)


func initialize_eus_sound(eus):
	eus_sound = FmodServer.create_event_instance("event:/eus_sound")
	eus_sound.set_2d_attributes(eus.global_transform)
	eus_sound.set_volume(.9)


func initialize_enemy_sounds(enemy: Enemy):
	if enemy.is_in_group("Roach"):
		roach_move_sound = FmodServer.create_event_instance("event:/roach_move")
		roach_move_sound.set_2d_attributes(enemy.global_transform)
		roach_move_sound.set_volume(.4)
	elif enemy.is_in_group("Blob"):
		pass


func inittialize_bed_sound(bed):
	bed_sound = FmodServer.create_event_instance("event:/cryo_bed")
	bed_sound.set_2d_attributes(bed.global_transform)
	bed_sound.set_volume(.6)


func inittialize_speech_sound(speaker):
	speech_sound = FmodServer.create_event_instance("event:/speech")
	speech_sound.set_2d_attributes(speaker.global_transform)
	speech_sound.set_volume(.2)


func initialize_cryo_machine_sound(machine):
	cryo_machine_sound = FmodServer.create_event_instance("event:/cryo_machine")
	cryo_machine_sound.set_2d_attributes(machine.global_transform)
	cryo_machine_sound.set_volume(.1)


func initialize_sounds():
	intro_sound = FmodServer.create_event_instance("event:/intro_scene")
	#bed_sound.set_2d_attributes(bed.global_transform)
	intro_sound.set_volume(.6)

	let_me_out_sound = FmodServer.create_event_instance("event:/let_me_out")
	let_me_out_sound.set_volume(.7)
	
	shatter_glass_sound = FmodServer.create_event_instance("event:/glass_shatter")
	shatter_glass_sound.set_volume(.4)


func pause():
	FmodServer.set_global_parameter_by_name("GamePause", PAUSED)


func unpause():
	FmodServer.set_global_parameter_by_name("GamePause", RUNNING)


func play_main_loop(loop_level):
	if not is_instance_valid(event):
		event = FmodServer.create_event_instance("event:/the_forgotten2.rpp")
	event.set_volume(.3)
	event.start()
	set_main_loop_parameter(loop_level)


func stop_main_loop():
	event.stop(1)


func play_custom_sound(transform, custom_event, volume, pitch: float = 1):
	var new_event = FmodServer.create_event_instance(custom_event)
	if transform:
		new_event.set_2d_attributes(transform)
	new_event.set_volume(volume)
	new_event.set_pitch(pitch)
	new_event.start()
	return new_event


func play_eus_sound():
	eus_sound.start()


func play_cryo_machine_sound():
	cryo_machine_sound.start()


func play_speech_sound(pitch):
	speech_sound.set_pitch(pitch)
	speech_sound.start()


func play_let_me_out():
	let_me_out_sound.start()


func get_let_me_out_state():
	return let_me_out_sound.get_playback_state()


func play_shatter_glass():
	shatter_glass_sound.start()


func play_intro_sound():
	intro_sound.start()


func play_bed_sound():
	bed_sound.start()


func play_footstep():
	footstep_sound.start()


func play_crowbar_swing():
	crowbar_swing_sound.start()


func play_crowbar_swing_fast():
	crowbar_swing_fast_sound.start()


func play_heartbeat():
	heartbeat_sound.start()


func stop_heartbeat():
	heartbeat_sound.stop(1)


func play_enemy_move_sound(enemy: Enemy):
	if enemy.is_in_group("Roach"):
		roach_move_sound.start()
	elif enemy.is_in_group("Blob"):
		pass
