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


func attack(_position, _attackName, _target=null): # The function to attack the player ###Base attacking could be built off of this later
	_attackTarget = _target
	var _attackData = utils.attackJSON[_attackName]
	
	$AttackRaycast.target_position = to_local(_position) # Points the raycast towards the player
	if _attackData["type"] == "ranged": # If a ranged attack set up and adopt a projectile instance
		var projectile = _projectileScene.instantiate()
		var _direction = $AttackRaycast.target_position.normalized()
		var _speed = _attackData["speed"]
		var _lifetime = _attackData["lifetime"]
		var _damage = _attackData["damage"]
		var _texture = _attackData["projectileSprite"]
		var _size = Vector2(_attackData["projectileSize"][0],_attackData["projectileSize"][1])
		var _durability = _attackData["durability"]
		projectile.generateProjectile(_direction,get_parent().position,_speed,_lifetime,_texture,_size,_damage,_durability)
		add_child(projectile)
	elif _attackData["type"] == "melee": # If a melee attack, cause the player a set amount of damage
		position = to_local(_position)
		$effectRange.get_node("CollisionShape2D").shape.radius = _attackData["radius"]
		_damage = _attackData["damage"]
		$effectRange.body_entered.connect(_applyDamage)
	else:
		queue_free()
func _applyDamage(input):
	for body in $effectRange.get_overlapping_bodies():
		if _attackTarget == null:
			body.damage(_damage)
		elif _attackTarget == body:
			body.damage(_damage)
	queue_free()
