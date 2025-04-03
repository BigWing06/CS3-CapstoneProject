extends Control

@onready var itemSlotDisplay = preload("res://inventory/craftingMenu/itemSlotDisplay.tscn")

@onready var gridContainer = $HBoxContainer/GridContainer
@onready var displaySectionContainer = $HBoxContainer/displaySection/container
@onready var resourceGridContainer = displaySectionContainer.get_node("GridContainer")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for item in utils.resourceJSON.keys():
		if "recipe" in utils.resourceJSON[item].keys():
			var itemDisplay = itemSlotDisplay.instantiate()
			itemDisplay.display(item)
			itemDisplay.pressed.connect(func(): _displayForCraft(item))
			gridContainer.add_child(itemDisplay)
	_displayForCraft("wood")
			
func _displayForCraft(resource):
	for child in resourceGridContainer.get_children():
		child.queue_free()
	var resourceInfo = utils.resourceJSON[resource]
	displaySectionContainer.get_node("resourceName").text = resourceInfo["name"]
	displaySectionContainer.get_node("TextureRect").texture = utils.loadImage(utils.appendToPath(utils.resourceImageRootPath, resource + ".png"))
	for requiredResource in resourceInfo["recipe"].keys():
		var requiredResourceDisplay = itemSlotDisplay.instantiate()
		requiredResourceDisplay.custom_minimum_size = Vector2(45, 45)
		requiredResourceDisplay.display(requiredResource, resourceInfo["recipe"][requiredResource])
		resourceGridContainer.add_child(requiredResourceDisplay)
