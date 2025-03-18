extends Node

@onready var main = get_node("/root/Main")
@onready var world = main.get_node("World")
@onready var player = world.get_node("Player")

var resourceManager = preload("res://inventory/resourceManager.gd").new()
var basePosition = Vector2(500, 400) #would like to eventually have this set the position of the base in a world script
