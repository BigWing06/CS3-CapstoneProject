extends CharacterBody2D

var _enemyData = {}
var _speed
var _movementType
var _target = Vector2(0, 0)
var _startingHealth
var _hybrid = false
var _player
@onready var _raycast = $AttackRaycast
@export var _PROJECTILE_SPAWN_RADIUS = 5
@onready var _rangedObject = preload("res://Enemy/Attacks/RangedObject.tscn")
var _resourceJSONPath = "res://Enemy/enemyTypes.json"
var _resourceJSONText = FileAccess.get_file_as_string(_resourceJSONPath)
var _resouceJSON = JSON.parse_string(_resourceJSONText)
var _attackData
func _ready():
	_enemyData = _resouceJSON
	_update("polar_bear") #choose animal from json file
	$AttackCooldown.wait_time=_attackData["attackCooldown"]
	$AttackCooldown.start()

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
	_updateAttackType(x)
func _updateAttackType(_type: String):
	var _enemyType = _enemyData[_type]
	_attackData = global.attackTypes[_enemyType["attack"]]
	if _attackData["attackType"] == "melee":
		set_collision_layer_value(5,true)
	elif _attackData["attackType"] == "ranged":
		set_collision_layer_value(5,false)
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if _hybrid:
		_movementType = "playerFocused"
func _on_area_2d_body_exited(body: Node2D) -> void:
	if _hybrid:
		_movementType = "baseFocused"
func _attack():

	_raycast.target_position = to_local(global.player.position)
	if _attackData["attackType"] == "ranged":
		var projectile = _rangedObject.instantiate()
		projectile.setDirection((_raycast.target_position).normalized())
		projectile.setSpeed(_attackData["speed"])
		add_child(projectile)


func _on_attack_cooldown_timeout() -> void:
	_attack()
