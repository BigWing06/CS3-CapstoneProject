extends Node2D

@export var min_spawn_distance: float = 400 #Can be increased or decreased as needed
@export var max_spawn_distance: float = 700

@export var _enemy_scene: PackedScene #This connects the enemy scene to this enemy_spawn scene (will have to change to fit the real enemies)
@export var _spawn_area: Rect2 #uses spawn area in the inspector to create an area. You can also set this on your own in the code to easily adjust.
@export var _spawn_area2: Rect2

@onready var _timer: Timer = $Timer
@onready var _timer2: Timer = $Timer2

func _ready() -> void:
	start_spawning()
	pass

func start_spawning(): #called when ever enemies should start spawning
	_timer.timeout.connect(_spawn_enemy) #Timer system that calls the spawn_enemy function everytime it runs.
	_timer2.timeout.connect(_spawn_enemy2)
	#_timer2.start()
	_timer.start()

func _spawn_enemy(): #Using the spawn_area this randomizes a place to spawn enemy.
	if _enemy_scene:
		var _enemy = _enemy_scene.instantiate()
		var _spawn_position = Vector2( 
			randf_range(_spawn_area.position.x, _spawn_area.end.y),
			randf_range(_spawn_area.position.y, _spawn_area.end.y)
		)
		_enemy.position = _spawn_position #Sets enemy position to the random position.
		get_parent().add_child(_enemy)

func _spawn_enemy2(): #Does the same thing as the last function but for the enemies that spawn farther away. (Change to real enemies in actual game)
	if _enemy_scene:
		var enemy2 = _enemy_scene.instantiate()
		var angle = randf() * TAU 
		var distance = randf_range(min_spawn_distance, max_spawn_distance) #keeps distance from the base
		
		var spawn_position2 = global.basePosition + Vector2(cos(angle), sin(angle)) * distance #creates an area around the base that enemies cant spawn
		enemy2.position = spawn_position2
		get_parent().add_child(enemy2)
