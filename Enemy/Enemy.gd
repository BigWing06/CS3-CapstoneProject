extends CharacterBody2D

var _enemyData = {}
var _speed
var _movementType
var _target = Vector2(0, 0)
var _startingHealth
var _hybrid = false
var _player

func _ready():
	_enemyData = utils.enemyJSON
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

	position += (_target - position)/_speed #sets a target for enemy to follow
	
func _update(x): #updates enemy variables
	_speed = _enemyData[x]["speed"]
	_movementType = _enemyData[x]["movement"]
	_startingHealth = _enemyData[x]["health"]

func _on_area_2d_body_entered(body: Node2D) -> void:
	if _hybrid:
		_movementType = "playerFocused"
func _on_area_2d_body_exited(body: Node2D) -> void:
	if _hybrid:
		_movementType = "baseFocused"
