extends ColorRect

func display(resource):
	var resourceDict = utils.resourceJSON[resource]
	$HBoxContainer/resourceName.text = resourceDict["name"]
