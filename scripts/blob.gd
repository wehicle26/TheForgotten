extends Enemy

signal split

var split_count = 0
var current_scale = 1
var blobScene: PackedScene = preload("res://scenes/Blob.tscn")
var interest_array = []
var direction_array = [
	Vector2(0, -1),
	Vector2(1, -1),
	Vector2(1, 0),
	Vector2(1, 1),
	Vector2(0, 1),
	Vector2(-1, 1),
	Vector2(-1, 0),
	Vector2(-1, -1)
]

func kill(_splat_direction):
	if split_count < 3:
		split.emit()
		split_count += 1

func split_blob():
	sprite_2d.modulate = white
	#gpu_particles_2d.amount = 64
	#gpu_particles_2d.emitting = true
	animation_player.play("Split")
	SoundManager.play_custom_sound(global_transform, "event:/roach_splat", 0.8)
	await animation_player.animation_finished
	var entities = get_tree().get_first_node_in_group("Entities")
	var new_blob = blobScene.instantiate()
	new_blob.split_count = split_count
	current_scale -= .25
	new_blob.scale = Vector2(current_scale, current_scale)
	new_blob.global_position = position + Vector2(15, 0)
	entities.add_child(new_blob)
	#new_blob = blobScene.instantiate()
	#new_blob.global_position = position + Vector2(-10, 0)
	#entities.add_child(new_blob)


func path_to_player():
	next_path_position = navigation_agent_2d.get_next_path_position()
	direction = to_local(next_path_position).normalized()
	for dir in direction_array:
		interest_array.append(direction.dot(dir))
	sprite_2d.look_at(next_path_position)
	velocity = direction * speed


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
	SoundManager.play_enemy_move_sound(self)
