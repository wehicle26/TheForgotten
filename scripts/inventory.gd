extends Resource

class_name Inventory

var crowbar = false
var flashlight = false
var blaster = false
var itemArray: Array[bool]


func insert(item: InventoryItem):
	if item.name == "crowbar":
		crowbar = true
		print("crowbar added")
	if item.name == "flashlight":
		flashlight = true
	if item.name == "blaster":
		blaster = true
	
	emit_changed()
