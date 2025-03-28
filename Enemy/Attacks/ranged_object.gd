extends Area2D


var _direction: Vector2 # Direction headed
var _speed: float
var _timeOut # Duration on screen before queue_free()
var _damage
var _target # position of target headed towards
func _ready():
	$TimeOut.wait_time=_timeOut # Sets and starts timeout timer
	$TimeOut.start()
	
	look_at(_target) # Rotates towards target
	
func _physics_process(delta: float) -> void: # Moves towards target
	position+=_direction*_speed*delta

func _on_body_entered(body: Node2D) -> void: # If it hits the player cause damage and then disappear
	global.player.damage(_damage)
	queue_free()
	
func setTarget(_x:Vector2,_playerPos:Vector2):
	_direction=_x
	_target = _playerPos
func setSpeed(_x:float):
	_speed=_x
func setLifetime(_x:float):
	_timeOut = _x
func setSprite(_texture:String,_collisionSize:Vector2):
	$Sprite2D.texture=load(_texture)
	$CollisionShape2D.shape.size = _collisionSize
func setDamage(_x:float):
	_damage = _x
	
func _on_time_out_timeout() -> void:
	queue_free()
