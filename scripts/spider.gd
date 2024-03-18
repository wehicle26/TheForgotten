extends Enemy

class_name Spider

@onready var danger: Node2D = $Danger
@onready var hitbox = $Hitbox
@onready var health = $Health
#@onready var label = $Label

var interest_array: Array = []
var danger_array = []
var direction_array = [
	Vector2(0, -1), # N
	Vector2(1, -1), # NE
	Vector2(1, 0), # E
	Vector2(1, 1), # SE
	Vector2(0, 1), # S
	Vector2(-1, 1), # SW
	Vector2(-1, 0), # W
	Vector2(-1, -1) # NW
]

func kill(_splat_direction):
	SoundManager.play_custom_sound(global_transform, "event:/blob_splat", 0.8)
	queue_free()


func path_to_player():
	next_path_position = navigation_agent_2d.get_next_path_position()
	direction = to_local(next_path_position).normalized()
	#var steering_force = calculate_direction()
	sprite_2d.look_at(next_path_position)
	#velocity = direction * speed
	#velocity += steering_force #* delta


func calculate_direction(reverse):
	next_path_position = navigation_agent_2d.get_next_path_position()
	direction = to_local(next_path_position).normalized()
	sprite_2d.look_at(next_path_position)
	interest_array.clear()
	for dir in direction_array:
		interest_array.append(direction.dot(dir))
	
	danger_array.resize(8)
	danger_array.fill(0)
	var i = 0
	for ray: RayCast2D in danger.get_children():
		if ray.is_colliding():
			danger_array[i - 1] = 2
			danger_array[i] = 5
			if i != 7:
				danger_array[i + 1] = 2
			else:
				danger_array[0] = 2
		i += 1
	
	var context_array: Array = []
	i = 0
	for dir in interest_array:
		context_array.append(dir - danger_array[i])
		i += 1
	
	var best_value
	if reverse:
		best_value = context_array.min()
	else:
		best_value = context_array.max()
	var best_direction: Vector2  = direction_array[context_array.find(best_value)]
	velocity = direction * speed
	var steering_force: Vector2 = (best_direction * speed) - velocity
	velocity += steering_force


func damage():
	sprite_2d.modulate = red
	var timer = get_tree().create_timer(0.5)
	await timer.timeout
	#sprite_2d.material.set_shader_parameter("active", false)
	sprite_2d.modulate = white


func _ready():
	var i = 0
	for dir in direction_array:
		direction_array[i] = dir.normalized()
		i += 1
	print(direction_array)
	sprite_2d.modulate = white
	line_of_sight.player_spotted.connect(_player_spotted)


func play_enemy_move_sound():
	SoundManager.play_custom_sound(global_transform, "event:/spider_move", 0.2)
