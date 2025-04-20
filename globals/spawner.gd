extends Node2D

@onready var _enemyScene = preload("res://Enemy/Enemy.tscn")

func spawnEnemy(position): #Spawns an enemy at a certain position
	var _enemy = _enemyScene.instantiate()
	_enemy.position = position #Sets enemy position to the random position.
	global.world.gameover.connect(_enemy.queue_free)
	get_parent().add_child(_enemy)
