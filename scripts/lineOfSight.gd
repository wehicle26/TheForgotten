extends Node2D

signal player_spotted

@export var cone_of_vision = deg_to_rad(360.0)
@export var angle_between_rays = deg_to_rad(10.0)
@export var max_view_distance = 200

func _ready():
	line_of_sight()
	
func _physics_process(delta):
	for ray in get_children():
		if ray.is_colliding() and ray.get_collider() is Player:
			player_spotted.emit()
			#print("player spotted")
			break
			
func line_of_sight():
	var ray_count = cone_of_vision / angle_between_rays
	
	for i in ray_count:
		var ray = RayCast2D.new()
		ray.set_collision_mask_value(2, true)
		var angle = angle_between_rays * (i - ray_count / 2.0)
		ray.target_position = Vector2.UP.rotated(angle) * max_view_distance
		add_child(ray)
		ray.enabled = true
