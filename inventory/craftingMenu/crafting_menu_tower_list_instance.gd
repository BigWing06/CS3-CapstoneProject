extends Control

func update(towerPlacementData): #This function is to be called by the ready functionn inn the crafting menu script
	$HBoxContainer/Control/name.text = towerPlacementData['name']
