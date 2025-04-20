extends Control

var _slots = {}

func update(_items:Array):
	for item in _items:
		var _itemSlot = load("res://inventory/craftingMenu/itemSlotDisplay.tscn").instantiate()
		_itemSlot.custom_minimum_size = Vector2(85,85)
		_itemSlot.display(item["name"],item["amount"])
		_itemSlot.set_clickable(false)
		$hBox.add_child(_itemSlot)
		_slots[item["name"]] = _itemSlot
