extends VBoxContainer

var _itemUpdateScene = preload("res://inventory/item_update.tscn")

func itemsChanged(_item:String,_amount:int): # Create a new itemsChanged and updates its values
	var _itemUpdate = _itemUpdateScene.instantiate()
	_itemUpdate.resource = _item
	_itemUpdate.amount = _amount
	add_child(_itemUpdate)
