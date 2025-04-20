var _inventory = {"resources":{}, "tools":{}}

signal resourcesChanged(resource, amount)

func add(resource: String, amount: int) -> void: #Adds an amount of a specific resrouce to inventory
	if _checkItem(resource):
		var list
		if _isResource(resource):
			list = "resources"
		if _isTool(resource):
			list = "tools"
		if _hasItem(resource):
			_inventory[list][resource] += amount
			if _inventory[list][resource] == 0: #If there is none of a resource it gets removed from dictionary
				_inventory[list].erase(resource) 
		else:
			_inventory[list][resource] = amount
		resourcesChanged.emit(resource, amount)

func addResourceDict(resourceDict: Dictionary, multiplier = 1): #Adds or removes (based on multiplier) all of the resources in the provided dictionary and amount
	for resource in resourceDict:
		add(resource, resourceDict[resource]*multiplier)

func getAmount(resource: String) -> int: #Gets amount of a specific resource in inventory
	if _hasItem(resource):
		if _isTool(resource):
			return _inventory["tools"][resource]
		if _isResource(resource):
			return _inventory["resources"][resource]
	return 0
		
func hasAmount(resource: String, amount: int) -> bool: #Checks to see if a specified amount of a resource is in the inventory
	if _hasItem(resource):
		if amount <= getAmount(resource):
			return true
	return false

func hasResourceDict(resourceDict: Dictionary) -> bool: #Checks to see if the inventory has the resources passed in by the dictionary
	for resource in resourceDict.keys():
		if not hasAmount(resource, resourceDict[resource]):
			return false
	return true

func getResourceList() -> Array: #Returns list of keys in the resources dictionary
	return _inventory["resources"].keys()

func getToolsList() -> Array: #Returns list of keys in the tools dictionary 
	return _inventory["tools"].keys()

func getResourceDict() -> Dictionary: #Returns a dictionary containg resouces and amounts that are in inventory
	var output = {}
	for resource in getResourceList():
		output[resource] = getAmount(resource)
	return output
	
func getToolDict() -> Dictionary: #Returns a dictionary containg tools and amounts that are in inventory
	var output = {}
	for resource in getToolsList():
		output[resource] = getAmount(resource)
	return output

func _checkItem(resource: String) -> bool: #Checks to make sure resource is a valid resrouce otherwise throws error
	if global.resourceManager.isItem(resource): 
		return true
	else:
		push_error(str(resource) + " is not a valid resource string")
		return false

func _hasItem(item: String) -> bool:
	if (item in getResourceList()):
		return true
	if (item in getToolsList()):
		return true
	return false
		
func _isTool(item):
	return item in utils.toolsJSON.keys()
	
func _isResource(item):
	return item in utils.resourceJSON.keys()

func clear():
	for resource in getResourceDict().keys():
		add(resource, getAmount(resource)*-1)
