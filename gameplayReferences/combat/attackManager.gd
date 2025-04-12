extends Node2D

var _target = Vector2(0, 0)

@export var defaultRangedAttackSight:int
@export var defaultMeleeAttackSight:int

@onready var _queuedRangedAttackRange = $queuedRangedAttackRange
@onready var _queuedMeleeAttackRange = $queuedMeleeAttackRange
@onready var _attackCooldown = $attackCooldown
@onready var _attackScene = preload("res://gameplayReferences/combat/attack.tscn")

var _queuedMeleeAttack
var _queuedRangedAttack

@onready var attackNode = get_parent().get_node("attack")

var _queuedAttack = null # The next attack to be used
var _nearTarget = false # If the player is within the attack radius
var _attackTarget
var _randMeleeAttackList
var _randRangedAttackList
var _targetMode
var _attackMode = []

func _setupAttacks(attackData, targetMode):
	_targetMode = targetMode
	var _meleeAttackDict = utils.readFromJSON(attackData, "meleeAttacks")
	if _meleeAttackDict != null:
		_randMeleeAttackList = utils.randWeightedListSetup(_meleeAttackDict) #Generates the attack list to pull from
	var _rangedAttackDict = utils.readFromJSON(attackData, "rangedAttacks")
	if _rangedAttackDict != null:
		_randRangedAttackList = utils.randWeightedListSetup(_rangedAttackDict)
	_queueAttacks()
	_getNewTarget()
	
func _getNewTarget():
	if _targetMode == "player":
		var players = get_tree().get_nodes_in_group("player")
		var closestPlayer = players[0]
		var closestPosition = global_position.distance_to(players[0].position)
		for player in players:
			if global_position.distance_to(player.position) < closestPosition:
				closestPlayer = player
				global_position.distance_to(player.position)
		_attackTarget = closestPlayer
	elif _targetMode == "enemy":
		var enemies = get_tree().get_nodes_in_group("enemy")
		var closestEnemy = enemies[0]
		var closestPosition = global_position.distance_to(enemies[0].position)
		for enemy in enemies:
			if global_position.distance_to(enemy.position) < closestPosition:
				closestEnemy = enemy
				global_position.distance_to(enemy.position)
		_attackTarget = closestEnemy

func _checkForTarget():
	if _attackCooldown.is_stopped():
		if _queuedMeleeAttack:
			if _attackTarget in _queuedMeleeAttackRange.get_overlapping_bodies():
				_sendAttack(_attackTarget, _queuedMeleeAttack)
			elif _attackTarget in _queuedRangedAttackRange.get_overlapping_bodies() and _queuedRangedAttack:
				_sendAttack(_attackTarget, _queuedRangedAttack)
			else:
				_getNewTarget()
		else:
			if _attackTarget in _queuedRangedAttackRange.get_overlapping_bodies() and _queuedRangedAttack:
				_sendAttack(_attackTarget, _queuedRangedAttack)
			else:
				_getNewTarget()

func _sendAttack(_attackTarget, _attack):
	var _instancedAttack = _attackScene.instantiate()
	var world = get_parent().get_parent()
	world.add_child(_instancedAttack)
	_instancedAttack.attack(to_local(_attackTarget.position), _attack, get_parent(), _attackTarget)
	_attackCooldown.wait_time = utils.attackJSON[_attack]["cooldown"]
	_attackCooldown.start()
	_queueAttacks()

func _queueAttacks(): # Prepared the next attacks values
	_queuedMeleeAttack = null
	_queuedRangedAttack = null
	if _randMeleeAttackList != null:
		_queuedMeleeAttack = _randMeleeAttackList.pick_random()
		_queuedMeleeAttackRange.get_node("CollisionShape2D").shape.radius = utils.attackJSON[_queuedMeleeAttack]["radius"]
	if _randRangedAttackList != null:
		_queuedRangedAttack =_randRangedAttackList.pick_random()
		_queuedRangedAttackRange.get_node("CollisionShape2D").shape.radius = utils.attackJSON[_queuedRangedAttack]["radius"]
