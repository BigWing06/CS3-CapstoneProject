extends Control
@onready var inventoryContinaer = preload("res://inventory/craftingMenu/itemSlotDisplay.tscn")
@onready var gridContainer = $GridContainer
@onready var _player = get_node("/root/Main/World/Player")
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
		container.add_to_group("inventoryMenu")
		gridContainer.add_child(container)
