extends Node

#This script is to be used to handle keyboard and mouse events by emiting signals
signal scrollUp
signal scrollDown
signal buildScrollUp
signal buildScrollDown
signal leftClick
signal rightClick
signal interact
signal mouseModeChange(mode)
signal UI_Mouse(_location)
@onready var tilemapMouseScene = preload("res://gameplayReferences/tileMapCursor.tscn")
var _regularMouseMode = "normal"
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS 
var scrollMode = "normal"
var _scrollTypes = {"normal":[scrollUp,scrollDown],"build":[buildScrollUp,buildScrollDown]} # List of all the types of scrolling signals and their actual signal objects
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("scrollUp"):
		_scrollTypes[scrollMode][0].emit() # Gets the current scroll up signal and emit its
	if Input.is_action_just_pressed("scrollDown"):
		_scrollTypes[scrollMode][1].emit() # Gets the current scroll down signal and emit its
	if Input.is_action_just_pressed("leftClick"):
		leftClick.emit()
	if Input.is_action_just_pressed("rightClick"):
		rightClick.emit()
		
func setMouseMode(mode):
	if mode == "tileMap":
		_createTilemapMouse()
		_regularMouseMode = "tileMap"
	else:
		_createNormalMouse()
		_regularMouseMode = "normal"
func _createTilemapMouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	global.world.add_child(tilemapMouseScene.instantiate())
	mouseModeChange.emit("tileMap")
func _createNormalMouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouseModeChange.emit("normal")
func toggleUIState(_value:bool):
	UI_Mouse.emit(_value)
	if _value:
		_createNormalMouse()
	else:
		setMouseMode(_regularMouseMode)

func pauseMode(mode:bool):
	print(mode)
	get_tree().paused = mode
