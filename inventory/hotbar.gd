extends HBoxContainer

var hotbarItem = preload("res://inventory/hotbarItem.tscn")

func update(_resourcesToDisplay:Dictionary): #This functions takes in the resource dictionary object 
	for child in get_children():
		child.queue_free()
	for resource in _resourcesToDisplay:
		var item = hotbarItem.instantiate()
		add_child(item)
		item.get_node("amountLbl").text = str(_resourcesToDisplay[resource])
		item.texture = load(global.resourceManager.getResourceProperty(resource, "icon"))
		
		
