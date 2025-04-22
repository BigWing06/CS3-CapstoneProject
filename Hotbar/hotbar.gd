extends Control

var _slots = {}

func update(_items:Array): # Creates and itemSlotDisplay for each tool, sets parameters, and adds it to the hotbar
	for item in _items:
		var _itemSlot = load("res://inventory/craftingMenu/itemSlotDisplay.tscn").instantiate()
		_itemSlot.custom_minimum_size = Vector2(85,85)
		_itemSlot.display(item["name"],item["amount"])
		_itemSlot.add_to_group("hotbarSlots")
		_itemSlot.set_clickable(false)
		add_child(_itemSlot)
		_slots[item["name"]] = _itemSlot

func set_active_tool(_toolName:String): # Changes the selected tool
	_slots[_toolName].set_active()
	var mouseMode = utils.readFromJSON(utils.toolsJSON[_toolName],"mouse")
	if mouseMode:
		if mouseMode == "tileMap":
			input.setMouseMode("tileMap")
		else:
			input.setMouseMode("normal")
	else:
		input.setMouseMode("normal")
		
