extends StaticBody2D

@onready var wave = get_parent().get_node("WaveSystem")

var _baseSpawnDistance = 500

func _ready() -> void:
	position = global.basePosition #Moves base to the base position
	$enemySpawner.start()

func _spawnEnemyBase(): #Using _baseSpawnDistance, spawns an enemy in a random angle that distance away from the base
	spawner.spawnEnemy(utils.getRandomRadiusPosition(global.basePosition, _baseSpawnDistance)) #Spawns the enemy at a random location around the base
	wave.enemies_spawned_this_wave +=1
	
