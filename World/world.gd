extends Node2D

var _playerScene = preload("res://Player/player.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var inventory = load("res://inventory/inventory.gd").new()
	inventory.add("exampleResource",10)
	print(inventory.getAmount("exampleResource"))
	global.world = self
	var _player = _playerScene.instantiate()
	self.add_child(_player)
