extends CharacterBody2D

@export var speed = 400
@export var player: Node2D

@onready var navigation_agent_2d = $NavigationAgent2D

func _physics_process(delta):
	var directon = to_local(navigation_agent_2d.get_next_path_position()).normalized()
	velocity = directon * speed
	move_and_slide()
	
func make_path():
	navigation_agent_2d.target_position = player.global_position


func _on_navigation_timer_timeout():
	make_path()
