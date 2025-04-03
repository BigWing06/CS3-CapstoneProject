extends Control
@onready var inventoryContinaer = preload("res://inventory/craftingMenu/itemSlotDisplay.tscn")
@onready var gridContainer = $GridContainer
func _ready() -> void:
	global.player.inventory.resourcesChanged.connect(update)
	update("", 5)
func update(changed, amount): #Updates the inventory sceneInstances to match the currenty inventory dict passed in
	var inventoryDict = global.player.inventory.getResourceDict()
	for child in gridContainer.get_children():
		child.queue_free()
	var resources = inventoryDict.keys()
	resources.sort()
	for resource in resources:
		var container = inventoryContinaer.instantiate()
		container.display(resource, inventoryDict[resource])
		gridContainer.add_child(container)
