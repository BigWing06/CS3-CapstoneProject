extends Area2D


var _direction: Vector2
var _speed: float
var _timeOut
var _damage
func _ready():
	$TimeOut.wait_time=_timeOut
	$TimeOut.start()

func _physics_process(delta: float) -> void:
	position+=_direction*_speed*delta


func _on_body_entered(body: Node2D) -> void:
	global.player.damage(_damage)
	queue_free()
func setDirection(_x:Vector2):
	_direction=_x
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
