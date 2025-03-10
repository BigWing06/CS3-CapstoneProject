extends Node

var resourceManager = preload("res://inventory/resourceManager.gd").new()
var playerPosition = Vector2(0, 0) #placeholder so values are not null
var basePosition = Vector2(500, 400) #would like to eventually have this set the position of the base in a world script
 
