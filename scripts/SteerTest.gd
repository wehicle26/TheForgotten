extends CharacterBody2D

@onready var danger: Node2D = $Danger
@onready var path_2d = $"../.."
@onready var path_follow_2d = $".."
@onready var line_2d = $Line2D
@onready var label = $Label

var speed = 20
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

var target_pos

func _ready():
	var i = 0
	for dir in direction_array:
		direction_array[i] = dir.normalized()
		i += 1


func _physics_process(delta):
	target_pos = get_global_mouse_position()
	calculate_direction()
	move_and_slide()


func calculate_direction():
	#path_follow_2d.progress += 1
	#var next_path_position = path_follow_2d.
	target_pos = target_pos
	#look_at(target_pos)
	interest_array.clear()
	
	var i = 0
	for dir in direction_array:
		interest_array.append(target_pos.dot(dir))
		#interest_array[i] += strafe_array[i]
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
	
	var context_array: Array = []
	i = 0
	for dir in interest_array:
		context_array.append(dir - danger_array[i])
		i += 1
	
	var best_value
	#if reverse:
		#best_value = context_array.min()
	#else:
	best_value = context_array.max()
	var best_direction: Vector2  = direction_array[context_array.find(best_value)]
	#line_2d.points[1] = best_direction
	velocity = target_pos * speed
	var steering_force: Vector2 = (best_direction * speed) - velocity
	velocity += steering_force
	label.text = str(best_direction)
	best_direction = Vector2(best_direction.x + 10, best_direction.y + 10)
	line_2d.points[1] = best_direction
	return best_direction
#
#@onready var path_2d: Path2D = $"../.."
#@onready var path_follow_2d: PathFollow2D = $".."
#
#@export var max_speed = 20
#@export var steer_force = 0.1
#@export var look_ahead = 100
#@export var num_rays = 8
#
## context array
#var ray_directions = []
#var interest = []
#var danger = []
#
#var chosen_dir = Vector2.ZERO
##var velocity = Vector2.ZERO
#var acceleration = Vector2.ZERO
#
#func _ready():
	#interest.resize(num_rays)
	#danger.resize(num_rays)
	#ray_directions.resize(num_rays)
	#for i in num_rays:
		#var angle = i * 2 * PI / num_rays
		#ray_directions[i] = Vector2.RIGHT.rotated(angle)
#
#
#func _physics_process(_delta):
	#set_interest()
	#set_danger()
	#choose_direction()
	#var desired_velocity = chosen_dir.rotated(rotation) * max_speed
	#velocity = velocity.lerp(desired_velocity, steer_force)
	##rotation = velocity.angle()
	##velocity = Vector2.RIGHT * max_speed
	#move_and_slide()
#
#
#func get_path_direction(pos):
	#var offset = path_2d.curve.get_closest_offset(pos)
	#path_follow_2d.progress += 1
	#return path_follow_2d.transform.x
#
#func set_interest():
	## Set interest in each slot based on world direction
	#var path_direction = get_path_direction(position).normalized()
	#for i in num_rays:
		#var d = ray_directions[i].rotated(rotation).dot(path_direction)
		#interest[i] = max(0, d)
#
#func set_danger():
	## Cast rays to find danger directions
	#var space_state = get_world_2d().direct_space_state
	#for i in num_rays:
		#var ray_query = PhysicsRayQueryParameters2D.create(position,
		#position + ray_directions[i].rotated(rotation) * look_ahead, 2)
		#var result = space_state.intersect_ray(ray_query)
		#danger[i] = 1.0 if result else 0.0
#
#
#func choose_direction():
	## Eliminate interest in slots with danger
	#for i in num_rays:
		#if danger[i] > 0.0:
			#interest[i] = 0.0
#
		## Choose direction based on remaining interest
		#chosen_dir = Vector2.ZERO
	#for i in num_rays:
		#chosen_dir += ray_directions[i] * interest[i]
		#chosen_dir = chosen_dir.normalized()
