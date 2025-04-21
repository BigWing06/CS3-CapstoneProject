extends Node2D

@onready var base = get_parent().get_node("base")
@onready var player = get_parent().get_node("Player")
@onready var current_Wave = 1
@onready var timer: Timer = $Timer
@onready var timer2: Timer = $Timer2
var waveIncrease = RandomNumberGenerator.new()


var enemies_spawned_this_wave: int = 1 #Counts the number of enemies that have spawned
var max_enemies_this_wave: int = 0 #The max amount of enemies that can spawn that wave.

func _ready():
	start_wave()
	global.waveSystem = self

func start_wave(): #Function that actually starts and resets every wave. Max number of enemies increases.
	var increase = waveIncrease.randf_range(2, 5)
	enemies_spawned_this_wave = 0
	max_enemies_this_wave = 6 + (current_Wave) * increase
	print("Max Enemies: ", max_enemies_this_wave) #Debug

func _on_timer_timeout(): #Checks to see if the max number of enemies spanwed in wave has been reached, if not then calls the spawning functions.
	if enemies_spawned_this_wave < max_enemies_this_wave:
		print(max_enemies_this_wave)
		global.player._spawnEnemyPlayer() #Calls spawner for around player
		base._spawnEnemyBase() #Calls spawner for base
		print("Enemies spawned: ", enemies_spawned_this_wave) #Debug
	else:
		timer.stop() #Stops spawning

func check_for_wave_clear(): #Checks to see if all enemies have been taken out. (Once an enemy dies it should be removed from the scene and group)
	var remaining = get_tree().get_nodes_in_group("enemy").size()
	if remaining == 0: #0 enemies in group advances wave
		current_Wave += 1
		start_wave()
		print("Starting next wave!") #Debug

func _on_timer2_timeout(): 
	wave_check() #Debug

func wave_check(): #Debug (Delete when finished)
	check_for_wave_clear()
	print("Enemies in group: ", get_tree().get_nodes_in_group("enemy").size()) #Debug


@onready var _enemyScene = preload("res://Enemy/Enemy.tscn")

func spawnEnemy(position): #Spawns an enemy at a certain position
	enemies_spawned_this_wave += 1
	var _enemy = _enemyScene.instantiate()
	_enemy.position = position #Sets enemy position to the random position.
	global.world.gameover.connect(_enemy.queue_free)
	global.world.add_child(_enemy)
