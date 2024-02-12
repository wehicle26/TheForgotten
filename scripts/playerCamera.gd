extends Camera2D

@export var dead_zone = 160
@export var lerp_speed = 0.8
@onready var player = $".."

func _input(_event):
	pass
#	if event is InputEventMouseMotion:
#		var target = event.position - get_viewport().size * 0.5
#		if target.length() < DEAD_ZONE:
#			position = Vector2(0, 0)
#		else:
#			position = target.normalized() * (target.length() - DEAD_ZONE) * 0.5
func _process(delta):
	pass
	#var camera_position = player.global_position + (get_global_mouse_position() - player.global_position)*0.25
	#global_position = camera_position
	#global_position = global_position.lerp(camera_position, (1 * delta)) 
	#if global_position.distance_to(camera_position) <= 5: 
		#position = position.round() 
	#global_position = lerp(camera_position, global_position, lerp_speed)
	
