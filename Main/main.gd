extends Node2D

@onready var _healthBarScene = preload("res://HealthBar/health_bar.tscn")
@onready var _UIParentScene = preload("res://GUI/ui_parent.tscn")
@onready var _worldScene = preload("res://World/world.tscn")
@onready var _playerScene = preload("res://Player/Player.tscn")
@onready var _startScreen = $"Start Screen"
@onready var _worldViewport = $ViewportControl/WorldViewportContainer/WorldViewport
func _ready() -> void:
	global.main=self

func _createUI():
	var _healthBar = _healthBarScene.instantiate()
	self.add_child(_healthBar)
	var _UIParent = _UIParentScene.instantiate()
	self.add_child(_UIParent)
func _createWorld():
	var _world = _worldScene.instantiate()
	_worldViewport.add_child(_world)
	var _player = _playerScene.instantiate()
	_world.add_child(_player)

func getActivePlayer():
	return _worldViewport.get_node("World/Player")
func startGame():
	_startScreen.queue_free()
	_createWorld()
	_createUI()
