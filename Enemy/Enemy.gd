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
var _nearPlayer = false
var _enemyType
func _ready():
	_enemyData = _resouceJSON
	_update("polar_bear") #choose animal from json file

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
	_enemyType = _enemyData[x]
	

		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if _hybrid:
		_movementType = "playerFocused"
func _on_area_2d_body_exited(body: Node2D) -> void:
	if _hybrid:
		_movementType = "baseFocused"
func _attack():

	_raycast.target_position = to_local(global.player.position)
	if _attackData["type"] == "ranged":
		var projectile = _rangedObject.instantiate()
		projectile.setDirection((_raycast.target_position).normalized())
		projectile.setSpeed(_attackData["speed"])
		projectile.setLifetime(_attackData["lifetime"])
		projectile.setDamage(_attackData["damage"])
		add_child(projectile)
	elif _attackData["type"] == "melee":
		global.player.damage(_attackData["damage"])


func _on_attack_cooldown_timeout() -> void:
	if _nearPlayer:
		_attack()

func _on_attack_radius_body_entered(body: Node2D) -> void:
	_nearPlayer = true
	if $AttackCooldown.is_stopped():
		_getRandomAttack()
		$AttackCooldown.wait_time = _attackData["cooldown"]
		$AttackCooldown.start()
		_attack()
func _getRandomAttack():
	_attackData = global.attackTypes[_enemyType["attacks"]]
	$AttackRadius/CollisionShape2D.shape.radius = _attackData["radius"]

func _on_attack_radius_body_exited(body: Node2D) -> void:
	_nearPlayer = false
