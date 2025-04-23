extends Area2D


var _direction: Vector2 # Direction headed
var _speed: float
var _timeOut # Duration on screen before queue_free()
var _damage
var _target # position of target headed towards
var _durability
@onready var _player  = get_node("/root/Main/World/Player")
var _attacker
var _affectedGroups
var _attackerGroups
func _ready():
	$TimeOut.wait_time=_timeOut # Sets and starts timeout timer
	$TimeOut.start()
	
func _physics_process(delta: float) -> void: # Moves towards target
	position+=_direction*_speed*delta

func _checkValidTarget(target, attackableGroups): #Checks to see if the given target is able to be attacked
	for group in target.get_groups():
		if group in attackableGroups:
			return true
	return false

func _on_body_entered(body: Node2D) -> void: # If it hits the player cause damage and then disappear
	if(not body == _attacker):
		if body.is_in_group("base"):
			if not &"player" in _attackerGroups:
				body.healthChange(_damage*-1)
			queue_free()
		else:
			for group in _affectedGroups:
				if _checkValidTarget(body, group):
					body.healthChange(_damage*-1)
					_durability-=1
					if _durability <=0:
						queue_free()

func generateProjectile(attacker, targetPos:  Vector2, pos: Vector2, speed: float, lifetime: float, texture: String, collisionSize: Vector2,damage: float, durability: float, affectedGroups: Array):
	_affectedGroups = affectedGroups
	_attacker = attacker
	_attackerGroups = _attacker.get_groups()
	position = pos
	_direction = targetPos
	_speed = speed
	_timeOut = lifetime
	$Sprite2D.texture=utils.loadImage(texture)
	$CollisionShape2D.shape.size = collisionSize
	_damage = damage
	_durability = durability
	look_at(to_global(targetPos)) # Rotates towards target
func _on_time_out_timeout() -> void:
	queue_free()
