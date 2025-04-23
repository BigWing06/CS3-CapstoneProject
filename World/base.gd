extends StaticBody2D

var _health = 500
var wave
signal healthChanged
signal death

@onready var healthBar = $healthBar
func _ready() -> void:
	healthBar.max_value = _health
	healthBar.value = _health
	wave = get_parent().get_node("WaveSystem")

func spawnBase(pos:Vector2):
	position = pos

func healthChange(_amount:float): # Funciton to cause damage to player
	_health+=_amount
	healthChanged.emit()
	if _amount < 0:
		if _health<=0:
			death.emit()
	elif _amount > 0:
		_health+=_health
		healthChanged.emit()
		
func updateHealthbar():
	healthBar.value = _health
	
