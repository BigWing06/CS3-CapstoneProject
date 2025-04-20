func getResources() -> Array: #Returns a list of resources from the resources JSON file
	return utils.resourceJSON.keys()
	
func getTools() -> Array: #Returns a list of resources from the resources JSON file
	return utils.toolsJSON.keys()
	
func isItem(resource: String) -> bool: #Checks to see if resource is a valid resource in the resource JSON file
	return resource in getResources() or resource in getTools()
	
func getResourceProperty(resource: String, property: String): #Returns the value for the resoruce and property specified out of the resource JSON file
	if resource in getResources():
		if property in utils._resourceJSON[resource].keys():
			return utils._resourceJSON[resource][property]
		else:
			push_error(property + " is not a valid resource property")
	else:
		push_error(resource + " is not a valid resource")
