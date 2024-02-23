extends Node

class_name Battery

@export var max_charge = 30.0

signal no_power
var on
var current_charge = 0.0

func _ready():
	current_charge = max_charge
	on = false

func _process(delta):
	if on and current_charge > 0:
		current_charge -= 1 * delta
		#flashlight.flicker(false)
	elif current_charge <= max_charge / 3.0:
		#flashlight.flicker(true)
		pass
	elif current_charge <= 0:
		no_power.emit()
		
func _on_flashlight_flashlight_toggle(isOn):
	on = isOn
	print("flashlight on: ", on)
	print(current_charge)
