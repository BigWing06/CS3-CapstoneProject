extends StaticBody2D

var _baseSpawnDistance = 500

func spawnBase(pos:Vector2):
	position = pos
	$enemySpawner.start()
func _spawnEnemyBase(): #Using _baseSpawnDistance, spawns an enemy in a random angle that distance away from the base
	spawner.spawnEnemy(utils.getRandomRadiusPosition(global.world.basePosition, _baseSpawnDistance)) #Spawns the enemy at a random location around the base
