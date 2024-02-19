extends Resource

class_name Inventory

var crowbar = false
var flashlight = false
var itemArray : Array[bool]

func insert(item : InventoryItem):
	if item.name == "crowbar":
		crowbar = true
		print("crowbar added")
	if item.name == "flashlight":
		flashlight = true
