extends Control

@onready var itemSlotDisplay = preload("res://inventory/craftingMenu/itemSlotDisplay.tscn")

@onready var gridContainer = $HBoxContainer/GridContainer
@onready var displaySectionContainer = $HBoxContainer/displaySection/container
@onready var resourceGridContainer = displaySectionContainer.get_node("GridContainer")

var _selectedResource
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for item in utils.resourceJSON.keys():
		if "recipe" in utils.resourceJSON[item].keys():
			var itemDisplay = itemSlotDisplay.instantiate()
			itemDisplay.display(item)
			itemDisplay.pressed.connect(func(): _displayForCraft(item))
			gridContainer.add_child(itemDisplay)
	_displayForCraft("wood")
			
func _displayForCraft(resource): #Called to display new item to craft
	_selectedResource = resource
	for child in resourceGridContainer.get_children(): #removes all the items from the old required resources display
		child.queue_free()
	var resourceInfo = utils.resourceJSON[resource]
	displaySectionContainer.get_node("resourceName").text = resourceInfo["name"]
	displaySectionContainer.get_node("TextureRect").texture = utils.loadImage(utils.appendToPath(utils.resourceImageRootPath, resource + ".png"))
	for requiredResource in resourceInfo["recipe"].keys(): #Instances the itemSlotDisplay class to show the new required resrouces for crafting
		var requiredResourceDisplay = itemSlotDisplay.instantiate()
		requiredResourceDisplay.custom_minimum_size = Vector2(45, 45)
		requiredResourceDisplay.display(requiredResource, resourceInfo["recipe"][requiredResource],global.player.inventory.hasAmount(requiredResource, resourceInfo["recipe"][requiredResource]))
		resourceGridContainer.add_child(requiredResourceDisplay)
	_checkResourceCraftability()
func _checkResourceCraftability(): #Checks to see if the selected resoruce is craftible
	var resourceInfo = utils.resourceJSON[_selectedResource]
	if global.player.inventory.hasResourceDict(resourceInfo["recipe"]):
		displaySectionContainer.get_node("craftButton").disabled = false
	else:
		displaySectionContainer.get_node("craftButton").disabled = true

func _on_craft_button_pressed() -> void:
	var inventory = global.player.inventory
	inventory.add(_selectedResource, 1)
	inventory.addResourceDict(utils.resourceJSON[_selectedResource]["recipe"], -1)
	_checkResourceCraftability()
	_displayForCraft(_selectedResource) ### This is a bit terrible
