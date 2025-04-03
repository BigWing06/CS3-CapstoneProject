extends TextureButton

func display(resource, amount = -2): #Called by the crafting menu script to show a specific resource
	var amountLbl = $amountLbl
	var resourceData = utils.resourceJSON[resource]
	if amount != -2:
		amountLbl.visible = true
		amountLbl.text = str(amount)
	else:
		amountLbl.visible = false
	texture_normal = utils.loadImage(utils.appendToPath(utils.resourceImageRootPath, resource + ".png"))
	
