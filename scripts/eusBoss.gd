extends Enemy

class_name EusBoss

@onready var hitbox = $Hitbox
@onready var collision_shape_2d = $CollisionShape2D

var has_crashed = false
var previous_path_position: Vector2 = Vector2.ZERO
var target_position: Vector2

func kill(_splat_direction):
	#sprite_2d.material.set_shader_parameter("active", false)
	sprite_2d.modulate = white
	#gpu_particles_2d.amount = 64
	#gpu_particles_2d.emitting = true
	#animation_player.play("Death")
	#SoundManager.play_custom_sound(global_transform, "event:/roach_splat", 0.8)
	#await animation_player.animation_finished
	queue_free()


func damage():
	#if is_in_group("Roach"):
		#gpu_particles_2d.emitting = true
		#gpu_particles_2d.process_material.direction = - Vector3(direction.x, direction.y, 0)
		#SoundManager.play_custom_sound(global_transform, "event:/roach_hit", 0.5)
	#sprite_2d.material.set_shader_parameter("active", true)
	sprite_2d.modulate = red
	var timer = get_tree().create_timer(0.5)
	await timer.timeout
	#sprite_2d.material.set_shader_parameter("active", false)
	sprite_2d.modulate = white

func _ready():
	#sprite_2d.material.set_shader_parameter("active", false)
	sprite_2d.modulate = white
	line_of_sight.player_spotted.connect(_player_spotted)
	#SoundManager.initialize_enemy_sounds(self)


func _physics_process(_delta):
	move_and_slide()


func play_enemy_move_sound():
	pass
	#SoundManager.play_enemy_move_sound(self)


func make_path():
	player = get_tree().get_first_node_in_group("Player")
	if is_instance_valid(player):
		navigation_agent_2d.target_position = player.global_position


func path_to_player():
	next_path_position = navigation_agent_2d.get_next_path_position()
	direction = to_local(next_path_position).normalized()
	#sprite_2d.look_at(next_path_position)
	velocity = direction * speed
	previous_path_position = next_path_position


func smooth_look(delta):
	target_position = player.global_position - global_position
	var angle = target_position.angle()
	var r = sprite_2d.global_rotation
	var angle_delta = rotation_speed * delta
	angle = lerp_angle(r, angle, 1.0)
	angle = clamp(angle, r - angle_delta, r + angle_delta)
	sprite_2d.global_rotation = angle
	hitbox.global_rotation = angle
	collision_shape_2d.global_rotation = angle

func _player_spotted():
	is_player_spotted = true
	aggro_timer.start()


func _on_navigation_timer_timeout():
	make_path()


func _on_aggro_timer_timeout():
	pass
	#is_player_spotted = false


func _on_hitbox_area_entered(area):
	if area is Hitbox:
		hit_player.emit()
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.knockback_force = knockback_force
		attack.attack_position = global_position
		attack.stun_time = stun_time
		area.damage(attack)


func _on_move_sound_timer_timeout():
	play_enemy_move_sound()

