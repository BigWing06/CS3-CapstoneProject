extends Node

@onready var main = get_node("/root/Main")
@onready var UIParent = main.get_node("UIParent")
@onready var world = main.get_node("ViewportControl/WorldViewportContainer/WorldViewport/World")
var player
var resourceManager = preload("res://inventory/resourceManager.gd").new()
var WORLD_SEED = 22222222
var basePosition = Vector2(500, 400) #would like to eventually have this set the position of the base in a world script
var attackTypes = JSON.parse_string(FileAccess.get_file_as_string("res://Enemy/Attacks/attacks.json")) ### This needs moved when we implement the JSON script
var host = false
