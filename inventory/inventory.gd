var _inventory = {}

func add(resource: String, amount: int) -> void: #Adds an amount of a specific resrouce to inventory
	if _checkResource(resource):
		if _hasResource(resource):
			_inventory[resource] += amount
			if _inventory[resource] == 0: #If there is none of a resource it gets removed from dictionary
				_inventory.erase(resource) 
		else:
			_inventory[resource] = amount

func getAmount(resource: String) -> int: #Gets amount of a specific resource in inventory
	if _checkResource(resource):
		return _inventory[resource]
	return 0
		
func hasAmount(resource: String, amount: int) -> bool: #Checks to see if a specified amount of a resource is in the inventory
	if _hasResource(resource):
		if amount <= getAmount(resource):
			return true
	return false

func getResourceList() -> Array: #Returns list of keys in the dictionary
	return _inventory.keys()

func getResourceDict() -> Dictionary: #Returns a dictionary containg resouces and amounts that are in inventory
	var output = {}
	for resource in _inventory.keys():
		output[resource] = _inventory[resource]
	return output

func _checkResource(resource: String) -> bool: #Checks to make sure resource is a valid resrouce otherwise throws error
	if global.resourceManager.isResource(resource): 
		return true
	else:
		push_error(str(resource) + " is not a valid resource string")
		return false

func _hasResource(resource: String) -> bool:
	return resource in _inventory.keys()
