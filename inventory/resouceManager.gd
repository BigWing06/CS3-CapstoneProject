var _resourceJSONPath = "res://inventory/resources.json"
var _resourceJSONText = FileAccess.get_file_as_string(_resourceJSONPath)
var _resouceJSON = JSON.parse_string(_resourceJSONText)

func getResources(): #Returns a list of resouces from the resources JSON file
	return _resouceJSON.keys()
	
func isResource(resource: String): #Checks to see if resource is a valid resource in the resource JSON file
	return resource in getResources()
	
func getResourceProperty(resource: String, property: String): #Returns the value for the resoruce and property specified out of the resource JSON file
	if resource in getResources():
		if property in _resouceJSON[resource].keys():
			return _resouceJSON[resource][property]
		else:
			push_error(property + " is not a valid resource property")
	else:
		push_error(resource + " is not a valid reasource")
