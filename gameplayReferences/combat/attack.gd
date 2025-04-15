extends Node2D

@onready var _raycast = $AttackRaycast
@onready var attackRadius = $attackRadius
@onready var _effectRange = $effectRange

@onready var _projectileScene = preload("res://gameplayReferences/combat/rangedObject.tscn")

var _queuedAttackTarget
var _queuedAttackData
var _targetInRange
var _damage
var _attackTarget
var _attacker


func attack(_position, _attackName, attacker, _target=null): # The function to attack the player ###Base attacking could be built off of this later
	_attackTarget = _target #node that the attack is directed at
	_attacker = attacker #node that is carrying out the attack
	var _attackData = utils.attackJSON[_attackName] #JSON data of the attack being carried out
	_raycast.position = attacker.position
	_raycast.target_position = to_local(_position) # Points the raycast towards the player
	if _attackData["type"] == "ranged": # If a ranged attack set up and adopt a projectile instance
		var projectile = _projectileScene.instantiate()
		var _direction = _raycast.target_position.normalized()
		var _speed = _attackData["speed"]
		var _lifetime = _attackData["lifetime"]
		var _damage = _attackData["damage"]
		var _texture = _attackData["projectileSprite"]
		var _size = Vector2(_attackData["projectileSize"][0],_attackData["projectileSize"][1])
		var _durability = _attackData["durability"]
		projectile.generateProjectile(_attacker, _direction,to_local(attacker.position),_speed,_lifetime,_texture,_size,_damage,_durability)
		get_parent().add_child(projectile) #projectiles get apoted by world node 
	elif _attackData["type"] == "melee": # If a melee attack, cause the player a set amount of damage
		position = attacker.position + _position
		_effectRange.get_node("CollisionShape2D").shape.radius = _attackData["radius"]
		_damage = _attackData["damage"]
		_effectRange.body_entered.connect(_applyDamage)
	else:
		queue_free()
func _applyDamage(input): #Used for melee attacks and applies the damage of the attack to anyone node not the attacker in range 
	for body in _effectRange.get_overlapping_bodies():
		if not body == _attacker:
			if _attackTarget == null:
				body.healthChange(-_damage)
				queue_free()
			elif _attackTarget == body:
				body.healthChange(-_damage)
				queue_free()
	
func _on_attack_timeout_timeout() -> void:
	queue_free()
