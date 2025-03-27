extends Area2D


var _direction: Vector2 = Vector2(1,1)
var _speed: float = 300
var _timeOut = 1

func _ready():
	$TimeOut.wait_time=_timeOut
	$TimeOut.start()

func _physics_process(delta: float) -> void:
	position+=_direction*_speed*delta


func _on_body_entered(body: Node2D) -> void:
	queue_free()
func setDirection(_x:Vector2):
	_direction=_x
func setSpeed(_x:float):
	_speed=_x


func _on_time_out_timeout() -> void:
	queue_free()
