extends HSlider

var master: FmodBus
var music: FmodBus
var fx: FmodBus

func _ready():
	master = FmodServer.get_bus("bus:/")
	music = FmodServer.get_bus("bus:/Music")
	fx = FmodServer.get_bus("bus:/Fx")
	value = GlobalState.master_volume


func _on_value_changed(value):
	master.volume = value
