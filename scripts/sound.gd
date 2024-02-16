extends Node

class_name Sound
enum {MAIN_LOOP_INTRO, MAIN_LOOP_CURIOUS, MAIN_LOOP_EERIE, MAIN_LOOP_DRONE, MAIN_LOOP_GARBLED}
var event: FmodEvent = null

func _ready():
	initialize_fmod()


func initialize_fmod():
	FmodServer.add_listener(0, self)
	FmodServer.load_bank("res://sounds/banks/Desktop/Master.strings.bank", 
	FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL)
	FmodServer.load_bank("res://sounds/banks/Desktop/Master.bank", 
	FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL)
	FmodServer.load_bank("res://sounds/banks/Desktop/MainLoop.bank", 
	FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL)
	FmodServer.load_bank("res://sounds/banks/Desktop/Sounds.bank", 
	FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL)

	event = FmodServer.create_event_instance("event:/the_forgotten2.rpp")
	event.set_volume(.5)
	event.start()
	FmodServer.set_global_parameter_by_name("mainLoopLevel", MAIN_LOOP_CURIOUS)
