extends Node2D

@onready var enemy = $enemyBody

var _enemyData = {}
var _speed
var _movementType
var _target = Vector2(0, 0)
var _startingHealth
var _hybrid = false
var _player

var _resourceJSONPath = "res://Enemy/enemyTypes.json"
var _resourceJSONText = FileAccess.get_file_as_string(_resourceJSONPath)
var _resouceJSON = JSON.parse_string(_resourceJSONText)

func _ready():
	_enemyData = _resouceJSON
	_update("beaver") #choose animal from json file

func _physics_process(delta):
	#changes target and specifies hybrid
	if _movementType == "baseFocused":
		_target = global.basePosition
	elif _movementType == "playerFocused":
		_target = global.player.position
	else:
		_target = global.basePosition
		_hybrid = true 

	enemy.position += (_target - enemy.position)/_speed #sets a target for enemy to follow
	
func _update(x): #updates enemy variables
	_speed = _enemyData[x]["speed"]
	_movementType = _enemyData[x]["movement"]
	_startingHealth = _enemyData[x]["health"]

func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if _hybrid:
		_movementType = "playerFocused"

func _on_area_2d_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if _hybrid:
		_movementType = "baseFocused"
