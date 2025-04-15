extends Node2D

var _target = Vector2(0, 0)

@export var defaultRangedAttackSight:int
@export var defaultMeleeAttackSight:int

@onready var _queuedRangedAttackRange = $queuedRangedAttackRange
@onready var _queuedMeleeAttackRange = $queuedMeleeAttackRange
@onready var _attackCooldown = $attackCooldown

@onready var _attackScene = preload("res://gameplayReferences/combat/attack.tscn")

var _queuedMeleeAttack #Stores the next melee attack that will be used
var _queuedRangedAttack #Stores the next ranged attack that will be used
var _attackTarget #Node that is currently set as target 
var _randMeleeAttackList #list of avaliable melee attacks
var _randRangedAttackList #Listof avaliable ranged attacks
var _targetMode #Chagnes how the next target is selcted
var _attackMode = [] #Stores which type of attacks are currently avaliable (based off of target distance/range)

func _setupAttacks(attackData, targetMode):
	_targetMode = targetMode
	
	#Generates the list of attacks that can be used
	var _meleeAttackDict = utils.readFromJSON(attackData, "meleeAttacks")
	if _meleeAttackDict != null:
		_randMeleeAttackList = utils.randWeightedListSetup(_meleeAttackDict)
	var _rangedAttackDict = utils.readFromJSON(attackData, "rangedAttacks")
	if _rangedAttackDict != null:
		_randRangedAttackList = utils.randWeightedListSetup(_rangedAttackDict)
		
	_queueAttacks()
	_getNewTarget()
	
func _getNewTarget():
	if _targetMode[0] == "targetGroup":
		var nodes = get_tree().get_nodes_in_group(_targetMode[1])
		if len(nodes) != 0:
			var closestNode = nodes[0]
			var closestPosition = global_position.distance_to(nodes[0].position)
			for node in nodes:
				if global_position.distance_to(node.position) < closestPosition:
					closestNode = node
					global_position.distance_to(node.position)
			_attackTarget = closestNode

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

func _sendAttack(_attackTarget, _attack): #Exectues an attack
	var _instancedAttack = _attackScene.instantiate()
	var world = get_parent().get_parent()
	world.add_child(_instancedAttack)
	_instancedAttack.attack(to_local(_attackTarget.position), _attack, get_parent(), _attackTarget)
	_attackCooldown.wait_time = utils.attackJSON[_attack]["cooldown"]
	_attackCooldown.start()
	_queueAttacks()

func _queueAttacks(): # Prepared the next attack values
	_queuedMeleeAttack = null
	_queuedRangedAttack = null
	if _randMeleeAttackList != null:
		_queuedMeleeAttack = _randMeleeAttackList.pick_random()
		_queuedMeleeAttackRange.get_node("CollisionShape2D").shape.radius = utils.attackJSON[_queuedMeleeAttack]["radius"]
	if _randRangedAttackList != null:
		_queuedRangedAttack =_randRangedAttackList.pick_random()
		_queuedRangedAttackRange.get_node("CollisionShape2D").shape.radius = utils.attackJSON[_queuedRangedAttack]["radius"]
