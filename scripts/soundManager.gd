extends Node

enum {MAIN_LOOP_INTRO, MAIN_LOOP_CURIOUS, MAIN_LOOP_EERIE, MAIN_LOOP_DRONE, MAIN_LOOP_GARBLED}
var event: FmodEvent = null
var intro_sound: FmodEvent
var footstep_sound : FmodEvent
var crowbar_swing_sound : FmodEvent
var roach_move_sound : FmodEvent
var bed_sound : FmodEvent
var let_me_out_sound : FmodEvent
var shatter_glass_sound : FmodEvent

func _ready():
	initialize_fmod()
	initialize_sounds()

func initialize_fmod():
	#FmodServer.add_listener(0, self)
	FmodServer.load_bank("res://sounds/banks/Desktop/Master.strings.bank", 
	FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL)
	FmodServer.load_bank("res://sounds/banks/Desktop/Master.bank", 
	FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL)
	FmodServer.load_bank("res://sounds/banks/Desktop/MainLoop.bank", 
	FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL)
	FmodServer.load_bank("res://sounds/banks/Desktop/Sounds.bank", 
	FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL)


func set_main_loop_parameter(loopLevel):
	FmodServer.set_global_parameter_by_name("mainLoopLevel", loopLevel)


func initialize_player_sounds(player : Player):
	footstep_sound = FmodServer.create_event_instance("event:/footsteps")
	footstep_sound.set_2d_attributes(player.global_transform)
	footstep_sound.set_volume( .4 )
	
	crowbar_swing_sound = FmodServer.create_event_instance("event:/crowbar_swing")
	crowbar_swing_sound.set_2d_attributes(player.global_transform)
	crowbar_swing_sound.set_volume( .6 )


func initialize_enemy_sounds(enemy : Enemy):
	if enemy.is_in_group("Roach"):
		roach_move_sound = FmodServer.create_event_instance("event:/roach_move")
		roach_move_sound.set_2d_attributes(enemy.global_transform)
		roach_move_sound.set_volume( .4 )
	elif enemy.is_in_group("Blob"):
		pass


func inittialize_bed_sound(bed):
	bed_sound = FmodServer.create_event_instance("event:/cryo_bed")
	bed_sound.set_2d_attributes(bed.global_transform)
	bed_sound.set_volume( .6 )


func initialize_sounds():
	intro_sound = FmodServer.create_event_instance("event:/intro_scene")
	#bed_sound.set_2d_attributes(bed.global_transform)
	intro_sound.set_volume( .6 )
	
	let_me_out_sound = FmodServer.create_event_instance("event:/let_me_out")
	let_me_out_sound.set_volume( .7 )
	
	shatter_glass_sound = FmodServer.create_event_instance("event:/glass_shatter")
	shatter_glass_sound.set_volume(.4)


func play_main_loop():
	event = FmodServer.create_event_instance("event:/the_forgotten2.rpp")
	event.set_volume(.3)
	event.start()
	set_main_loop_parameter(MAIN_LOOP_INTRO)

func stop_main_loop():
	event.stop(1)

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


func play_enemy_move_sound(enemy : Enemy):
	if enemy.is_in_group("Roach"):
		roach_move_sound.start()
	elif enemy.is_in_group("Blob"):
		pass
