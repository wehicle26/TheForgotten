extends Node2D

@export var max_speed = 7
@export var steering_force = 0.1
@export var look_ahead = 100
@export var num_rays = 8

@onready var danger = $Danger
@onready var line_2d = $Line2D

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

# context array
#var ray_directions = []
var interest: Array = []
var danger_array: Array = []
var context_array: Array = []

var path_direction
var chosen_dir = Vector2.ZERO
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO

func _ready():
	pass
	#interest.resize(num_rays)
	#danger.resize(num_rays)
	##ray_directions.resize(num_rays)
	#for i in num_rays:
		#direction_array[i] = direction_array[i].normalized()
	
	#for i in num_rays:
		#var angle = i * 2 * PI / num_rays
		#ray_directions[i] = Vector2.RIGHT.rotated(angle)


func  _physics_process(delta):
	set_interest()
	set_danger()
	choose_direction()
	#var desired_velocity = chosen_dir.rotated(owner.rotation) * owner.default_speed
	#owner.velocity = owner.velocity.lerp(desired_velocity, steering_force)
	#owner.rotation = owner.velocity.angle()
	#move_and_slide()

#func create_danger_rays():
		#var ray_count = cone_of_vision / angle_between_rays
#
		#for i in ray_count:
			#var ray = RayCast2D.new()
			#ray.set_collision_mask_value(2, true)
			#var angle = angle_between_rays * (i - ray_count / 2.0)
			#ray.target_position = Vector2.UP.rotated(angle) * max_view_distance
			#add_child(ray)
			#ray.enabled = true

func set_interest():
	if owner and owner.has_method("get_path_direction"):
		path_direction = owner.get_path_direction()
		for i in num_rays:
			var interest_dot = direction_array[i].dot(path_direction)
			interest[i] = max(0, interest_dot)
	#else:
		#set_default_interest()
#
#
#func set_default_interest():
	#for i in num_rays:
		#var d = ray_directions[i].rotated(owner.rotation).dot(owner.transform.x)
		#interest[i] = max(0, d)


func set_danger():
	#var space_state = get_world_2d().direct_space_state
	for i in num_rays:
		var ray: RayCast2D = danger.get_child(i)
		if ray.is_colliding():
			danger_array[i - 1] += 5
			danger_array[i] += 8
			if i != 7:
				danger_array[i + 1] += 5
			else:
				danger_array[0] += 5
		i += 1
		#var ray_query = PhysicsRayQueryParameters2D.create(owner.position,
		#owner.position + ray_directions[i].rotated(owner.rotation) * look_ahead, 2)
		#var result = space_state.intersect_ray(ray_query)
		#danger_array[i] = 1.0 if result else 0.0


func choose_direction():
	for i in num_rays:
		context_array[i] = (interest[i] - danger_array[i])
	
	var best_value
	#if reverse:
		#best_value = context_array.min()
	#else:
		#best_value = context_array.max()
	var best_direction: Vector2  = direction_array[context_array.find(best_value)]
	line_2d.points[1] = best_direction
	var steering_force: Vector2 = (best_direction - path_direction)
	owner.velocity += steering_force * owner.speed
	return best_direction
