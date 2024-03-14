extends HSlider

func _ready():
	var master: FmodBus = FmodServer.get_bus("bus:/")
	var busses: FmodBank
	print(FmodServer.get_all_banks())
	#print(busses.get_bus_list())
