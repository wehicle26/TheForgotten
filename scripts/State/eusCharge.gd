extends State

class_name EusCharge

@export var enemy: EusBoss

var player: Player
var tween: Tween

func  _ready():
	enemy.hit_player.connect(_hit_player)


func enter():
	player = get_tree().get_first_node_in_group("Player")
	#enemy.get_node("AnimationPlayer").play("RESET")
	enemy.velocity = Vector2.ZERO
	enemy.speed = 0
	enemy.move_sound_timer.stop()
	SoundManager.play_custom_sound(enemy.global_transform, "event:/forklift", 1)
	await get_tree().create_timer(4).timeout
	#enemy.get_node("AnimationPlayer").play("Walk")
	
	#SoundManager.play_custom_sound(enemy.global_transform, "event:/eus_charge", 0.8)
	tween = get_tree().create_tween()
	enemy.speed = enemy.lunge_speed
	enemy.velocity = enemy.target_position.normalized() * enemy.speed
	
	tween.tween_property(enemy, "speed", enemy.default_speed, 3.5).set_trans(Tween.TRANS_BACK)
	await tween.finished
	enemy.has_crashed = true
	transitioned.emit(self, "eusIdle")


func physics_update(delta):
	#enemy.path_to_player()
	enemy.smooth_look(delta)
	pass


func _hit_player():
	tween.kill()
	enemy.velocity = Vector2.ZERO
	enemy.speed = 0
	enemy.has_crashed = true
	transitioned.emit(self, "eusIdle")
