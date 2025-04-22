extends Node2D

@export var baseSpawningDistance:int

@onready var base = get_parent().get_node("base")
@onready var player = get_parent().get_node("Player")
@onready var enemySpawner: Timer = $enemySpawner
@onready var waveTimer:Timer = $waveTimer
@onready var _enemyScene = preload("res://Enemy/Enemy.tscn")
var waveIncrease = RandomNumberGenerator.new()

var current_Wave = -1 #Variable to keep track of the current wave that will get incramented
var currentWaveInfo #Stores info of the active wave
var enemies_spawned_this_wave: int = 0 #Counts the number of enemies that have spawned
var max_enemies_this_wave: int = 0 #The max amount of enemies that can spawn that wave.
var currentRandomWeightedList #Stores the current list if using randomWeightedMode 

func _ready():
	start_wave()
	global.waveSystem = self

func start_wave(): #Function that actually starts and resets every wave. Max number of enemies increases.
	current_Wave += 1
	enemies_spawned_this_wave = 0
	if not current_Wave >= len(utils.wavesJSON):
		currentWaveInfo = utils.wavesJSON[current_Wave]
	else:
		currentWaveInfo = {"name":"Infinite Mode", "amount":round(randf()*current_Wave)+10, "duration":randi_range(10, 45), "type":"random"}
	max_enemies_this_wave = currentWaveInfo["amount"] #Checks to see how many enemies need to spawn this wave
	waveTimer.wait_time = currentWaveInfo["duration"]
	enemySpawner.wait_time = currentWaveInfo["duration"]/max_enemies_this_wave #Calculates how long to wait before spawning the next enemy
	if currentWaveInfo["type"] == "randomWeighted":
		currentRandomWeightedList = utils.randWeightedListSetup(currentWaveInfo["enemyData"])
	enemySpawner.start()
	waveTimer.start()
	print("wait time", currentWaveInfo["duration"]/max_enemies_this_wave)
	print("Max Enemies: ", max_enemies_this_wave) #Debug
		

func _on_enemy_spawner_timeout() -> void:
	if enemies_spawned_this_wave < max_enemies_this_wave:
		global.waveSystem.spawnEnemy(utils.getRandomRadiusPosition(global.world.basePosition, baseSpawningDistance), determineNextEnemyType(currentWaveInfo)) #Spawns the enemy at a random location around the base
		enemies_spawned_this_wave +=1

func determineNextEnemyType(wave):
	if wave["type"] == "orderedList":
		return wave["enemyData"][enemies_spawned_this_wave]
	elif wave["type"] == "random":
		return utils.getEnemies().pick_random()
	elif wave["type"] == "randomWeighted":
		return currentRandomWeightedList.pick_random()
	else:
		return utils.getEnemies().pick_random()

func spawnEnemy(position, enemy): #Spawns an enemy at a certain position
	print("spawning", enemy)
	var _enemy = _enemyScene.instantiate()
	_enemy.position = position #Sets enemy position to the random position.
	global.world.gameover.connect(_enemy.queue_free)
	global.world.add_child(_enemy)
	_enemy._update(enemy) #choose animal from json file
