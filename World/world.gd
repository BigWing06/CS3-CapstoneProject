extends Node2D

var _playerScene = preload("res://Player/Player.tscn")
@export var basePosition = Vector2(0,0)
@onready var base = $base
@onready var UIParent = get_node("/root/Main/UIParent")

var deathScreen = preload("res://deathScreen/death.tscn")
signal gameover
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var inventory = load("res://inventory/inventory.gd").new()
	inventory.add("exampleResource",10)
	print(inventory.getAmount("exampleResource"))
	global.world = self
	var _player = _playerScene.instantiate()
	self.add_child(_player)
	base.spawnBase(basePosition)
	base.death.connect(_onGameEnd)
	if global.tutorial:
		global.world.UIParent.get_node("tutorialController").displayMessage("res://tutorial1.png")

func _onGameEnd():
	input.setMouseMode("normal")
	base.death.disconnect(_onGameEnd)
	gameover.emit()
	print(get_tree())
	get_tree().change_scene_to_packed(deathScreen)
