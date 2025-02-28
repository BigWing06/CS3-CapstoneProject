var _resourceJSONPath = "res://inventory/resources.json"
var _resourceJSONText = FileAccess.get_file_as_string(_resourceJSONPath)
var _resourceJSON = JSON.parse_string(_resourceJSONText)

func getResources() -> Array: #Returns a list of resources from the resources JSON file
	return _resourceJSON.keys()
	
func isResource(resource: String) -> bool: #Checks to see if resource is a valid resource in the resource JSON file
	return resource in getResources()
	
func getResourceProperty(resource: String, property: String): #Returns the value for the resoruce and property specified out of the resource JSON file
	if resource in getResources():
		if property in _resourceJSON[resource].keys():
			return _resourceJSON[resource][property]
		else:
			push_error(property + " is not a valid resource property")
	else:
		push_error(resource + " is not a valid resource")
