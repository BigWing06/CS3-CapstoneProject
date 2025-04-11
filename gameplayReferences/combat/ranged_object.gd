extends Area2D


var _direction: Vector2 # Direction headed
var _speed: float
var _timeOut # Duration on screen before queue_free()
var _damage
var _target # position of target headed towards
var _durability
var _attacker
func _ready():
	$TimeOut.wait_time=_timeOut # Sets and starts timeout timer
	$TimeOut.start()
	
	#look_at(_target) # Rotates towards target
	
func _physics_process(delta: float) -> void: # Moves towards target
	position+=_direction*_speed*delta

func _on_body_entered(body: Node2D) -> void: # If it hits the player cause damage and then disappear
	if(not body == _attacker):
		body.healthChange(_damage*-1)
		_durability-=1
		if _durability <=0:
			queue_free()

func generateProjectile(attacker, targetPos:  Vector2, pos: Vector2, speed: float, lifetime: float, texture: String, collisionSize: Vector2,damage: float, durability: float):
	_attacker = attacker
	position = pos
	_direction = targetPos
	_speed = speed
	_timeOut = lifetime
	$Sprite2D.texture=load(texture)
	$CollisionShape2D.shape.size = collisionSize
	_damage = damage
	_durability = durability
func _on_time_out_timeout() -> void:
	queue_free()
