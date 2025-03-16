extends Node2D
var inventoryTest = load("res://inventory/inventory.gd").new()
func _ready():
	inventoryTest.add("exampleResource", 5)
	inventoryTest.add("exampleResource1", 5000000)
	get_parent().get_node("Hotbar").update(inventoryTest.getResourceDict())
