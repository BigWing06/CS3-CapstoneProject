extends StaticBody2D

var _baseSpawnDistance = 500
var _health = 500

signal healthChanged
signal death

@onready var healthBar = $healthBar

func _ready() -> void:
	healthBar.max_value = _health
	healthBar.value = _health
func spawnBase(pos:Vector2):
	position = pos
	$enemySpawner.start()
func _spawnEnemyBase(): #Using _baseSpawnDistance, spawns an enemy in a random angle that distance away from the base
	spawner.spawnEnemy(utils.getRandomRadiusPosition(global.world.basePosition, _baseSpawnDistance)) #Spawns the enemy at a random location around the base

func healthChange(_amount:float): # Funciton to cause damage to player
	_health+=_amount
	healthChanged.emit()
	if _amount < 0:
		if _health<=0:
			return #REMOVE THIS WHEN DONE TESTING
			death.emit()
	elif _amount > 0:
		_health+=_health
		healthChanged.emit()
		
func updateHealthbar():
	healthBar.value = _health
	
