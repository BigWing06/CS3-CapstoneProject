extends Node2D

@export var min_spawn_distance: float = 400 #Can be increased or decreased as needed
@export var max_spawn_distance: float = 700

@export var enemy_scene: PackedScene #This connects the enemy scene to this enemy_spawn scene (will have to change to fit the real enemies)
@export var enemy2_scene: PackedScene #Same as the other enemy scene (Will also have to change to fit the real enemies)
@export var spawn_area: Rect2 #uses spawn area in the inspector to create an area. You can also set this on your own in the code to easily adjust.
@export var spawn_area2: Rect2

@onready var timer: Timer = $Timer
@onready var timer2: Timer = $Timer2

func _ready() -> void:
	start_spawning()

func start_spawning(): #called when ever enemies should start spawning
	timer.timeout.connect(_spawn_enemy) #Timer system that calls the spawn_enemy function everytime it runs.
	timer2.timeout.connect(_spawn_enemy2)
	timer2.start()
	timer.start()

func _spawn_enemy(): #Using the spawn_area this randomizes a place to spawn enemy.
	if enemy_scene:
		var enemy = enemy_scene.instantiate()
		var spawn_position = Vector2( 
			randf_range(spawn_area.position.x, spawn_area.end.y),
			randf_range(spawn_area.position.y, spawn_area.end.y)
		)
		enemy.position = spawn_position #Sets enemy position to the random position.
		get_parent().add_child(enemy)

func _spawn_enemy2(): #Does the same thing as the last function but for the enemies that spawn farther away. (Change to real enemies in actual game)
	if enemy2_scene:
		var enemy2 = enemy_scene.instantiate()
		var angle = randf() * TAU 
		var distance = randf_range(min_spawn_distance, max_spawn_distance) #keeps distance from the base
		
		var spawn_position2 = global.basePosition + Vector2(cos(angle), sin(angle)) * distance #creates an area around the base that enemies cant spawn
		enemy2.position = spawn_position2
		get_parent().add_child(enemy2)
