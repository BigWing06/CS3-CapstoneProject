extends Node2D

var _playerScene = preload("res://Player/player.tscn")
@export var basePosition = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var inventory = load("res://inventory/inventory.gd").new()
	inventory.add("exampleResource",10)
	print(inventory.getAmount("exampleResource"))
	global.world = self
	$base.spawnBase(basePosition)
