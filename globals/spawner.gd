extends Node2D

@onready var _enemyScene = preload("res://Enemy/Enemy.tscn")
@onready var wave = get_parent().get_node("wave")
@onready var _enemy = _enemyScene.instantiate()

func spawnEnemy(position): #Spawns an enemy at a certain position
	var _enemy = _enemyScene.instantiate()
	_enemy.position = position #Sets enemy position to the random position.
	_enemy.add_to_group("enemies")
	get_parent().add_child(_enemy)
