extends Enemy

signal split

@onready var danger: Node2D = $Danger
@onready var hitbox = $Hitbox

var split_count = 0
var current_scale = 1
var blobScene: PackedScene = preload("res://scenes/Blob.tscn")
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
	if split_count < 3:
		split.emit()
		split_count += 1
	else:
		queue_free()

func split_blob():
	hitbox.queue_free()
	sprite_2d.modulate = white
	#gpu_particles_2d.amount = 64
	#gpu_particles_2d.emitting = true
	animation_player.play("Split")
	await animation_player.animation_finished
	var entities = get_tree().get_first_node_in_group("Entities")
	var new_blob = blobScene.instantiate()
	default_speed += 10
	new_blob.default_speed = default_speed
	new_blob.split_count = split_count
	current_scale -= .25
	new_blob.current_scale = current_scale
	new_blob.scale = Vector2(current_scale, current_scale)
	new_blob.global_position = position + Vector2(15, 0)
	entities.add_child(new_blob)
	
	new_blob = blobScene.instantiate()
	new_blob.split_count = split_count
	#current_scale -= .25
	new_blob.current_scale = current_scale
	new_blob.scale = Vector2(current_scale, current_scale)
	new_blob.global_position = position + Vector2(-15, 0)
	entities.add_child(new_blob)
	
	queue_free()


func path_to_player():
	next_path_position = navigation_agent_2d.get_next_path_position()
	direction = to_local(next_path_position).normalized()
	#var steering_force = calculate_direction()
	sprite_2d.look_at(next_path_position)
	#velocity = direction * speed
	#velocity += steering_force #* delta


func calculate_direction():
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
	
	var context_array: Array
	i = 0
	for dir in interest_array:
		context_array.append(dir - danger_array[i])
		i += 1
	var max = context_array.max()
	var best_direction: Vector2  = direction_array[context_array.find(max)]
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
	SoundManager.play_custom_sound(global_transform, "event:/blob_move", 0.6)
