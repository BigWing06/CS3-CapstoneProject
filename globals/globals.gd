extends Node

var resourceManager = preload("res://inventory/resourceManager.gd").new()
var worldPath = "/root/Main/World" # the world node path
var WORLD_SEED = randi_range(0,5000)
