extends Node2D

var _target = Vector2(0, 0)

@export var defaultRangedAttackSight:int
@export var defaultMeleeAttackSight:int

@onready var _raycast = $AttackRaycast # The raycast object uses to find the fasest path to the player
@onready var _rangedObject = preload("res://Enemy/Attacks/RangedObject.tscn") # The ranged object scene

@onready var _meleeAttackRange = $meleeAttackRange
@onready var _rangedAttackRange = $rangedAttackRange

@onready var attackNode = get_parent().get_node("attack")

var _queuedAttack = null # The next attack to be used
var _nearTarget = false # If the player is within the attack radius
var _attackTarget
var _randMeleeAttackList
var _randRangedAttackList
var _rangedAttackSight
var _meleeAttackSight
var _attackMode

func _setupAttacks(attackData, attackMode):
	_attackMode = attackMode
	var _meleeAttackDict = utils.readFromJSON(attackData, "meleeAttacks")
	if _meleeAttackDict != null:
		_randMeleeAttackList = utils.randWeightedListSetup(_meleeAttackDict) #Generates the attack list to pull from
	var _rangedAttackDict = utils.readFromJSON(attackData, "rangedAttacks")
	if _rangedAttackDict != null:
		_randRangedAttackList = utils.randWeightedListSetup(_rangedAttackDict)
	var _rangedAttackSight = utils.readFromJSON(attackData, "rangedSight")
	if _rangedAttackSight == null:
		_rangedAttackSight = defaultRangedAttackSight
		var _meleeAttackSight = utils.readFromJSON(attackData, "meleeSight")
	if _meleeAttackSight == null:
		_meleeAttackSight = defaultMeleeAttackSight
	_getNewTarget()
	$attackCooldown.start()
	
func _getNewTarget():
	if _attackMode == "player":
		var players = get_tree().get_nodes_in_group("player")
		var closestPlayer
		var closestPosition = 1000000000
		for player in players:
			if global_position.distance_to(player.position) < closestPosition:
				closestPlayer = player
				global_position.distance_to(player.position)
		_setTarget(closestPlayer)
	elif _attackMode == "enemy":
		var enemies = get_tree().get_nodes_in_group("enemy")
		var closestEnemy
		var closestPosition = 1000000000
		for enemy in enemies:
			if global_position.distance_to(enemy.position) < closestPosition:
				closestEnemy = enemy
				global_position.distance_to(enemy.position)
		print(closestEnemy)
		_setTarget(closestEnemy)

func _setTarget(_target):
	_attackTarget = _target
	if _target.get_collision_layer_value(2):
		_meleeAttackRange.set_collision_mask_value(2, true)
		_rangedAttackRange.set_collision_mask_value(2, true)
	if _target.get_collision_layer_value(3):
		_meleeAttackRange.set_collision_mask_value(3, true)
		_rangedAttackRange.set_collision_mask_value(3, true)
	_checkForTarget()

func _checkForTarget():
	if _attackTarget in _meleeAttackRange.get_overlapping_bodies():
		_loadNextAttack("melee")
	elif _attackTarget in _rangedAttackRange.get_overlapping_bodies():
		_loadNextAttack("ranged")

func _loadNextAttack(mode): # Prepared the next attacks values
	if mode == "melee" and _randMeleeAttackList != null:
		_queuedAttack = _randMeleeAttackList.pick_random()
	elif _randRangedAttackList != null:
		_queuedAttack =_randRangedAttackList.pick_random()
	if _queuedAttack != null:
		attackNode.queueAttack(_attackTarget, _queuedAttack)
		_queuedAttack = null
	
func _on_attack_cooldown_timeout() -> void: # When the attack has cooled down check to see if near player, and then attack again
		_checkForTarget()
		
