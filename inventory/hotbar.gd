extends HBoxContainer

var hotbarItem = preload("res://inventory/hotbarItem.tscn")

func update(_resourcesToDisplay:Dictionary): #This functions takes in the resource dictionary object 
	for child in get_children():
		child.queue_free()
	for resource in _resourcesToDisplay:
		var item = hotbarItem.new()
		$Hotbar.add_child(item)
