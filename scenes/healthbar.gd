extends ProgressBar
@onready var player = $"../.."
@onready var canvas_layer = $".."
@onready var health = $"../../Health"


func _ready():
	health.healthChanged.connect(update)
	update()
	
func update():
	value = health.health
	print (value)
	
# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_health_health_changed():
	update()
