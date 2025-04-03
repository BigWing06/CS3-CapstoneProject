extends Control

func display(resource): #Called by the crafting menu script to show a specific resource
	var resourceData = utils.resourceJSON[resource]
	$nameLbl.text = resourceData["name"]
	
