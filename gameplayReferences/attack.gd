extends Node2D

@onready var _raycast = $AttackRaycast
@onready var _rangedObject = preload("res://Enemy/Attacks/RangedObject.tscn") # The ranged object scene

@onready var attackRadius = $attackRadius

var _queuedAttackTarget
var _queuedAttackData

func queueAttack(_target, _attackName):
	var _attackData = utils.attackJSON[_attackName]
	attackRadius.get_node("CollisionShape2D").shape.radius = _attackData["radius"]
	_queuedAttackTarget = _target
	_queuedAttackData = _attackData
	_checkAttackRange()
	
func _attack(_target, _attackData): # The function to attack the player ###Base attacking could be built off of this later
	_raycast.target_position = to_local(_target.position) # Points the raycast towards the player
	if _attackData["type"] == "ranged": # If a ranged attack set up and adopt a projectile instance
		var projectile = _rangedObject.instantiate()
		var _direction = (_raycast.target_position).normalized()
		var _speed = _attackData["speed"]
		var _lifetime = _attackData["lifetime"]
		var _damage = _attackData["damage"]
		var _texture = _attackData["projectileSprite"]
		var _size = Vector2(_attackData["projectileSize"][0],_attackData["projectileSize"][1])
		var _durability = _attackData["durability"]
		projectile.generateProjectile(_direction,get_parent().position,_speed,_lifetime,_texture,_size,_damage,_durability)
		add_child(projectile)
	elif _attackData["type"] == "melee": # If a melee attack, cause the player a set amount of damage
		_target.damage(_attackData["damage"])

func _checkAttackRange():
	if _queuedAttackTarget in attackRadius.get_overlapping_bodies():
		_attack(_queuedAttackTarget, _queuedAttackData)
