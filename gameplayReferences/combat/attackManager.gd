extends Node2D

var _target = Vector2(0, 0)

@export var defaultRangedAttackSight:int
@export var defaultMeleeAttackSight:int

@onready var _queuedRangedAttackRange = $queuedRangedAttackRange
@onready var _queuedMeleeAttackRange = $queuedMeleeAttackRange
@onready var _attackCooldown = $attackCooldown

@onready var _attackScene = preload("res://gameplayReferences/combat/attack.tscn")

var _rangedCallable = func(): pass
var _meleeCallable = func(): pass
var _queuedMeleeAttack #Stores the next melee attack that will be used
var _queuedRangedAttack #Stores the next ranged attack that will be used
var _attackTarget #Node that is currently set as target 
var _lastAttackTarget
var _randMeleeAttackList #list of avaliable melee attacks
var _randRangedAttackList #Listof avaliable ranged attacks
var _attackableGroups #List of groups that can be attacked
var _attackMode = [] #Stores which type of attacks are currently avaliable (based off of target distance/range)

func _setupAttacks(attackData, attackableGroups):
	_attackableGroups = attackableGroups
	get_parent().targetChanged.connect(getTarget)
	#Generates the list of attacks that can be used
	var _meleeAttackDict = utils.readFromJSON(attackData, "meleeAttacks")
	if _meleeAttackDict != null:
		_randMeleeAttackList = utils.randWeightedListSetup(_meleeAttackDict)
	var _rangedAttackDict = utils.readFromJSON(attackData, "rangedAttacks")
	if _rangedAttackDict != null:
		_randRangedAttackList = utils.randWeightedListSetup(_rangedAttackDict)
	_queueAttacks()
	getTarget()

func _checkValidTarget(target): #Checks to see if the given target is able to be attacked
	for group in target.get_groups():
		if group in _attackableGroups:
			return true
	return false
	
func _checkForTarget(area:Area2D, queuedAttack, body=_attackTarget):
	if _attackCooldown.is_stopped():
		if _attackTarget in area.get_overlapping_bodies():
			_sendAttack(_attackTarget, queuedAttack)
		elif body in area.get_overlapping_bodies():
			if _checkValidTarget(body):
				_sendAttack(body, queuedAttack)

func _sendAttack(_attackTarget, _attack): #Exectues an attack
	var _instancedAttack = _attackScene.instantiate()
	var world = get_parent().get_parent()
	world.add_child(_instancedAttack)
	_instancedAttack.attack(to_local(_attackTarget.position), _attack, get_parent(), _attackTarget, _attackableGroups)
	_attackCooldown.wait_time = utils.attackJSON[_attack]["cooldown"]
	_attackCooldown.start()
	_queueAttacks()
	_lastAttackTarget = _attackTarget

func _queueAttacks(): # Prepared the next attack values
	_queuedMeleeAttack = null
	_queuedRangedAttack = null
	_queuedMeleeAttackRange.disconnect("body_entered", _meleeCallable)
	_queuedRangedAttackRange.disconnect("body_entered", _rangedCallable)
	if _randMeleeAttackList != null:
		_queuedMeleeAttack = _randMeleeAttackList.pick_random()
		_meleeCallable = func(body): _checkForTarget(_queuedMeleeAttackRange, _queuedMeleeAttack, body)
		_queuedMeleeAttackRange.get_node("CollisionShape2D").shape.radius = utils.attackJSON[_queuedMeleeAttack]["radius"]
		_queuedMeleeAttackRange.connect("body_entered", _meleeCallable)
	if _randRangedAttackList != null:
		_queuedRangedAttack =_randRangedAttackList.pick_random()
		_rangedCallable = func(body): _checkForTarget(_queuedRangedAttackRange, _queuedRangedAttack, body)
		_queuedRangedAttackRange.get_node("CollisionShape2D").shape.radius = utils.attackJSON[_queuedRangedAttack]["radius"]
		_queuedRangedAttackRange.connect("body_entered", _rangedCallable)


func _on_attack_cooldown_timeout() -> void:
	if _queuedMeleeAttack:
		_meleeCallable.call(_lastAttackTarget)
	if _queuedRangedAttack:
		_rangedCallable.call(_lastAttackTarget)


func getTarget() -> void:
	_attackTarget = get_parent().getTarget()
