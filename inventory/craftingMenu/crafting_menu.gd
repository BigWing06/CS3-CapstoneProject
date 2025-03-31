extends Control

@onready var gridContainer = $margin/GridContainer

func update(resourceDict: Dictionary): #This method updates the UI to show the supplied resource dictionary
	for container in gridContainer.get_children():
		container.queue_free()
	for resource in resourceDict.keys():
		var container = gridContainer.instantiate()
		
