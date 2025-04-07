extends Node

@onready var main = get_node("/root/Main")
@onready var UIParent = main.get_node("UIParent")
@onready var world = main.get_node("World")
@onready var player = world.get_node("Player")

var resourceManager = preload("res://inventory/resourceManager.gd").new()
var worldPath = "/root/Main/World" # the world node path
var WORLD_SEED = randi_range(0,5000)
var basePosition = Vector2(0, 0) #would like to eventually have this set the position of the base in a world script
var attackTypes = JSON.parse_string(FileAccess.get_file_as_string("res://Enemy/Attacks/attacks.json")) ### This needs moved when we implement the JSON script
