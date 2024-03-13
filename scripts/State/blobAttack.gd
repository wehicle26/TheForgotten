extends State


@export var enemy: Enemy

var player: Player
var retreat: bool = false

func  _ready():
	enemy = get_parent().get_parent()
	enemy.hit_player.connect(_hit_player)


func enter():
	retreat = false
	player = get_tree().get_first_node_in_group("Player")
	print("attack")
	enemy.get_node("AnimationPlayer").play("RESET")
	enemy.velocity = Vector2.ZERO
	enemy.speed = 0
	enemy.move_sound_timer.stop()
	await get_tree().create_timer(randf_range(1, 3)).timeout
	enemy.get_node("AnimationPlayer").play("Walk")
	if enemy.is_in_group("Roach"):
		SoundManager.play_custom_sound(enemy.global_transform, "event:/roach_attack", 0.8)
		enemy.play_enemy_move_sound()
		var tween = get_tree().create_tween()
		enemy.speed = enemy.lunge_speed
		
		tween.tween_property(enemy, "speed", enemy.default_speed, 0.5).set_trans(Tween.TRANS_BACK)
		await tween.finished
	
	transitioned.emit(self, "retreat")

func physics_update(_delta):
	if retreat:
		transitioned.emit(self, "retreat")
	var _direction = player.global_position - enemy.global_position
	#enemy.look_at(direction)
	enemy.path_to_player()
#
	#if direction.length() > attack_range:
		#transitioned.emit(self, "follow")


func _hit_player():
	retreat = true
