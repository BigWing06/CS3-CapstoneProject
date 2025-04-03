extends Control

@onready var inventoryContinaer = preload("res://inventory/craftingMenu/inventoryItemSlot.tscn")
@onready var craftingListInstance = preload("res://inventory/craftingMenu/craftingMenuListItem.tscn")
@onready var gridContainer = $margin/GridContainer

func _ready() -> void:
	global.player.inventory.resourcesChanged.connect(update)
	update("", 5)
	
	#Generates the crating menu list
	#for resource in utils.resourceJSON.keys():
		#if "recipe" in utils.resourceJSON[resource].keys():
			#var listItem = craftingListInstance.instantiate()
			#listItem.display(resource)
			#$margin/ScrollContainer/VBoxContainer.add_child(listItem)
			

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggleInventory"):
		_toggleMenu()
		
func _toggleMenu():
	visible = !visible

func update(changed, amount): #Updates the inventory sceneInstances to match the currenty inventory dict passed in
	var inventoryDict = global.player.inventory.getResourceDict()
	for child in $margin/GridContainer.get_children():
		child.queue_free()
	var resources = inventoryDict.keys()
	resources.sort()
	for resource in resources:
		var container = inventoryContinaer.instantiate()
		container.display(resource)
		gridContainer.add_child(container)
		
