extends Node

var playing = false
var master_volume: float = 0.5
var music_volume: float = 0.5
var sfx_volume: float = 0.5

var encounter1 = false
var encounter2 = false
var encounter3 = false
var encounter4 = false

var dialogue1 = false
var dialogue2 = false
var dialogue3 = false
var dialogue4 = false


func reset():
	encounter1 = false
	encounter2 = false
	encounter3 = false
	encounter4 = false
	
	#dialogue1 = false
	#dialogue2 = false
	#dialogue3 = false
	#dialogue4 = false
