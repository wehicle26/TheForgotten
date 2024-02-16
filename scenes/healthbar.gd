extends ProgressBar
@onready var player = $"../.."
@onready var canvas_layer = $".."




func update():
	value = player.currentHealth
	

# Called when the node enters the scene tree for the first time.
func _ready():
	update()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_health_health_changed():
	update()
