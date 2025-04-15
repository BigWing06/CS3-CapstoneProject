extends Control
@onready var inventoryContinaer = preload("res://inventory/craftingMenu/itemSlotDisplay.tscn")
@onready var gridContainer = $GridContainer
@onready var _main = get_node("/root/Main")
@onready var _player = _main.getActivePlayer()
func _ready() -> void:
	_player.inventory.resourcesChanged.connect(update)
	update("", 5)
func update(changed, amount): #Updates the inventory sceneInstances to match the currenty inventory dict passed in
	var inventoryDict = _player.inventory.getResourceDict()
	for child in gridContainer.get_children():
		child.queue_free()
	var resources = inventoryDict.keys()
	resources.sort()
	for resource in resources:
		var container = inventoryContinaer.instantiate()
		container.display(resource, inventoryDict[resource])
		gridContainer.add_child(container)
