extends CharacterBody2D

var _enemyData = {} # All JSON data on the enemy types
var _enemyType # The type of enemy
var _speed # The speed at which the enemy moves
var _movementType # The type of movment the enemy has
var _target = Vector2(0, 0)
var _startingHealth
var _hybrid = false
var _player

# Loads in the enemy types #  ###NOTE FOR LATER: Move this when we implement JSON script
var _resourceJSONPath = "res://Enemy/enemyTypes.json"
var _resourceJSONText = FileAccess.get_file_as_string(_resourceJSONPath)
var _resouceJSON = JSON.parse_string(_resourceJSONText)

@onready var _attackManager = $attackManager
@onready var _attack = $attack

var _queuedAttack # The next attack to be used
var _nearPlayer = false # If the player is within the attack radius

func _ready():
	_update("beaver") #choose animal from json file
	#_attackManager.call_deferred("_setupAttacks",_enemyData["attack"])
	
	

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
	_enemyType = x
	_enemyData = utils.enemyJSON[_enemyType]
	_speed = _enemyData["speed"]
	_movementType = _enemyData["movement"]
	_startingHealth = _enemyData["health"]
	_attackManager._setupAttacks(_enemyData["attack"], "player")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if _hybrid:
		_movementType = "playerFocused"
func _on_area_2d_body_exited(body: Node2D) -> void:
	if _hybrid:
		_movementType = "baseFocused"
