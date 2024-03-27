extends Enemy

class_name BroodMother

signal dead

var spit_scene: PackedScene = preload("res://scenes/Spit.tscn")
var egg_scene: PackedScene = preload("res://scenes/Egg.tscn")
@onready var danger: Node2D = $Danger
@onready var hitbox = $Hitbox
@onready var health = $Health
@onready var spit_spawn = $SpitSpawn
#@onready var steer = $Steer
@onready var state_machine = $StateMachine
@onready var collision_shape_2d = $CollisionShape2D
@onready var light = $Light

var berserk = false

#@onready var line_2d = $Line2D
@onready var label = $CanvasLayer/Label

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
var context_array: Array = []
var strafe_array: Array = [
	5, # N
	2, # NE
	0, # E
	2, # SE
	5, # S
	2, # SW
	0, # W
	2 # NW
]

var best_direction
var attack_array: Array = [
	"BMSpit",
	"BMLay",
	"BMLunge"
]


func _on_navigation_timer_timeout():
	player = get_tree().get_first_node_in_group("Player")
	make_path()
	
	var display_interest = ""
	var display_danger = ""
	var display_context = ""
	for j in range(0, 7):
		display_interest += str("%.01f" % interest_array[j]) + " "
		display_danger += str("%.01f" % danger_array[j]) + " "
		display_context += str("%.01f" % context_array[j]) + " "
	label.text = "Direction: " + str(direction) \
	+ "\nInterest: " + display_interest \
	+ "\nDanger: " + display_danger \
	+ "\nContext: " + display_context \
	+ str("\nBest Direction: ", best_direction) \
	+ "\nDistance to player: " + str(int(global_position.distance_to(player.global_position))) \
	+ str("\nState:  ", state_machine.current_state.name)


func get_next_attack():
	if health.health >= 75:
		#return attack_array[0]
		return attack_array[2]
	elif health.health < 75 and health.health >= 50:
		return attack_array.slice(0, 1).pick_random()
	elif health.health < 50 and health.health >= 25:
		return attack_array.pick_random()
	else:
		berserk = true
		return attack_array.pick_random()


func lay():
	var egg = egg_scene.instantiate()
	egg.global_position = global_position
	get_parent().add_child(egg)


func spit():
	var spit_proj: Spit = spit_scene.instantiate()
	get_parent().add_child(spit_proj)
	#spit_proj.global_rotation = global_rotation
	#spit_proj.global_position = spit_spawn.global_position
	spit_proj.transform = spit_spawn.global_transform
	SoundManager.play_custom_sound(global_transform, "event:/bm_spit", 1)
	light.turn_off()
	if not berserk:
		await get_tree().create_timer(randf_range(1, 3)).timeout
	else:
		await get_tree().create_timer(randf_range(0.5, 1)).timeout


func kill(_splat_direction):
	SoundManager.play_custom_sound(global_transform, "event:/blob_splat", 0.8)
	await animation_player.animation_finished
	hitbox.queue_free()
	dead.emit()
	move_sound_timer.stop()
	#queue_free()


func get_path_direction():
	next_path_position = navigation_agent_2d.get_next_path_position()
	direction = to_local(next_path_position).normalized()
	#var steering_force = calculate_direction()
	#look_at(next_path_position)
	#velocity = direction * speed
	#velocity += steering_force #* delta
	return direction


func calculate_direction(action):
	next_path_position = navigation_agent_2d.get_next_path_position()
	direction = to_local(next_path_position).normalized()
	#look_at(next_path_position)
	#danger.rotation = 0
	if is_instance_valid(player):
		sprite_2d.look_at(player.global_position)
		collision_shape_2d.look_at(player.global_position)
		collision_shape_2d.rotation += PI/2
		hitbox.look_at(player.global_position)
		spit_spawn.look_at(player.global_position)

	interest_array.clear()
	
	var i = 0
	for dir in direction_array:
		interest_array.append(direction.dot(dir))
		if not action == "follow":
			 
			interest_array[i] += strafe_array[i]
		i += 1
	
	danger_array.resize(8)
	danger_array.fill(0)

	i = 0
	for ray: RayCast2D in danger.get_children():
		if ray.is_colliding():
			danger_array[i - 1] += 2
			danger_array[i] += 5
			if i != 7:
				danger_array[i + 1] += 2
			else:
				danger_array[0] += 2
		i += 1
	
	context_array.clear()
	i = 0
	for dir in interest_array:
		context_array.append(dir - danger_array[i])
		i += 1
	
	var best_value = 0
		#best_value = context_array.min()
	#else:
	best_value = context_array.max()
		
	best_direction = direction_array[context_array.find(best_value)]
	
	if action == "retreat":
		best_direction = Vector2(-best_direction.x, -best_direction.y)
	#line_2d.points[1] = best_direction
	if action == "idle":
		return
	velocity = direction * speed
	var steering_force: Vector2 = (best_direction * speed) - velocity
	velocity += steering_force


func damage():
	sprite_2d.modulate = red
	SoundManager.play_custom_sound(global_transform, "event:/bm_screech", 1)
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
	SoundManager.play_custom_sound(global_transform, "event:/boss_spawn", 1)
	await get_tree().create_timer(7).timeout
	


func play_enemy_move_sound():
	SoundManager.play_custom_sound(global_transform, "event:/spider_move", 0.2)

