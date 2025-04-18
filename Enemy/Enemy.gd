extends CharacterBody2D

var _enemyData = {} # All JSON data on the enemy types
var _enemyType # The type of enemy
var _speed # The speed at which the enemy moves
var _targetType # The type of movment the enemy has
var _target = Vector2(0, 0)
var _hybrid = false
@onready var _player = get_node("/root/Main/World/Player")
var _health
var _genericAttackGroups = ["base", "player"]

signal healthChanged
signal targetExited
signal death

@onready var _healthChangeScene = preload("res://inventory/health_change.tscn")

@onready var _attackManager = $attackManager
@onready var _attack = $attack
@onready var _sprite = $enemySpr
@onready var _healthbar = $healthBar
@onready var _sightRadius = $sightRadius

func _ready():
	_update(["wolf", "polarbear", "penguin"].pick_random()) #choose animal from json file
	_getNewTarget()
	
func _physics_process(delta):
	_sprite.look_at(_target.position)
	velocity = (_target.position - position).normalized()*_speed/2 #sets a target for enemy to follow
	if velocity.x > 0:
		_sprite.flip_v = false
	elif velocity.x < 0:
		_sprite.flip_v = true
	move_and_slide()
	if velocity.length() > 0:
		_sprite.play("walk")
	
func _update(x): #updates enemy variables
	_enemyType = x
	_enemyData = utils.enemyJSON[_enemyType]
	_sprite.sprite_frames = load(utils.appendToPath(utils.enemyAnimationRootPath, _enemyType+"Animations.tres"))
	_speed = _enemyData["speed"]
	_targetType = _enemyData["targetMode"]
	_health = _enemyData["health"]
	_healthbar.max_value = _health
	_healthbar.value = _health
	_attackManager._setupAttacks(_enemyData["attack"], ["targetGroup", ["player", "base"]])
	
func healthChange(_amount:float): # Funciton to cause damage to player
	_health+=_amount
	_healthbar.value = _health
	healthChanged.emit()
	if _amount < 0:
		if _health<=0:
			death.emit()
		_displayHealthChange(_amount)
		$DamageAnimation.play("Damage")
	elif _amount > 0:
		_health+=_health
		_displayHealthChange(_health)
		healthChanged.emit()

func _displayHealthChange(_amount: float): # Creates a scene to display an animation of the health change near the player
	var _healthChangeScene = _healthChangeScene.instantiate()
	add_child(_healthChangeScene)
	_healthChangeScene.display(_amount,$HealthChangePoint.position)
	$DamageAnimation.play("Heal")

func _getNewTarget(): #Used for getting the target of the enemy
	if _targetType == "hybrid":
		if _sightRadius.get_overlapping_bodies() != []:
			var closetBaseNode = utils.getClosestNode(self, get_tree().get_nodes_in_group("player"))
			if closetBaseNode != null:
				_target = closetBaseNode
			else:
				var nodes = []
				for group in _genericAttackGroups:
					nodes += get_tree().get_nodes_in_group(group)
				var closestNode = utils.getClosestNode(self, nodes)
				if closestNode != null:
					_target = closestNode
				else:
					_target = global.world.get_node("base")
		else:
			_target = global.world.get_node("base")
	elif _targetType == "baseFocused":
		_target = global.world.get_node("base")
	elif _targetType == "playerFocused":
		_target = global.world.get_node("Player")

func getTarget():
	return _target

func _on_death() -> void:
	queue_free()

func _on_sight_radius_body_exited(body: Node2D) -> void:
	if body == _target and _targetType == "hybrid":
		targetExited.emit()

func _on_target_exited() -> void:
	_getNewTarget()
