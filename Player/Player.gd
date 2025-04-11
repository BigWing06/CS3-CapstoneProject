extends CharacterBody2D

signal chunkChanged
signal healthChanged
signal death

@onready var _healthChangeScene = preload("res://Player/health_change.tscn") # The health change animation scene
@onready var _attackScene = preload("res://gameplayReferences/combat/attack.tscn")
@export var speed = 400
@onready var inventory = preload("res://inventory/inventory.gd").new()

var screen_size
var _chunk: Vector2i
var _preChunk: Vector2i = Vector2i(0,0) #Keeps track of the previous chunk the player was in
var _health
var _enemySpawnDistance = 100 #Sets how far away from the player enemies will spawn
var _toolList = []
var _mode
var _modeInt = 0
@export var _STARTING_HEALTH = 20
func _ready():
	screen_size = get_viewport_rect().size
	global.world.get_node("TileMaps").playerRenderNeighborChunks(getCurrentChunk())
	_health= _STARTING_HEALTH
	$enemySpawner.start()
	inventory.add("stoneSword", 1)
	inventory.add("bow", 1)
	##### Remove these as they are used for test of the gui
	inventory.add("wood", 100)
	inventory.add("snowball", 100)
	for tool in inventory.getToolsList():
		_toolList.append(tool)
	_mode = _toolList[0]
	input.leftClick.connect(mainInteract)
	input.scrollUp.connect(func(): cycleMode(1))
	input.scrollDown.connect(func(): cycleMode(-1))
func getCurrentChunk() -> Vector2i: #Returns the current chunk that the player is in
	return global.world.get_node("TileMaps").getChunk(position)

func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	position += velocity*delta

func _process(delta):
	if (getCurrentChunk() != _chunk): #Determined if the player has entered a new chunk
		_preChunk = _chunk
		_chunk = getCurrentChunk()
		chunkChanged.emit()
		
func healthChange(_amount:float): # Funciton to cause damage to player
	_health+=_amount
	healthChanged.emit()
	if _amount < 0:
		if _health<=0:
			death.emit()
		_displayHealthChange(_amount)
		$DamageAnimation.play("Damage")
	elif _amount > 0:
		_health+=_health
		_displayHealthChange(_health)
		healthChanged.emit()

func _displayHealthChange(_amount: float): # Creates a scene to display an animation of the health change near the player
	var _healthChange = _healthChangeScene.instantiate()
	add_child(_healthChange)
	_healthChange.display(_amount,$HealthChangePoint.position)
	$DamageAnimation.play("Heal")

func getHealth() -> int:
	return _health
	
func _on_chunk_changed() -> void: #Run when the player enters a new chunk
	global.world.get_node("TileMaps").playerRenderNeighborChunks(getCurrentChunk())

func _on_death() -> void:
	#self.queue_free()
	pass
	
func _spawnEnemyPlayer():
	spawner.spawnEnemy(utils.getRandomRadiusPosition(position, _enemySpawnDistance))
	
func attack(attackName):
	var attackData = utils.attackJSON[attackName]
	if attackData["type"] == "ranged":
		var attackRange = attackData["type"]
		var mouseVector = get_local_mouse_position()
		if mouseVector.length() > attackData["radius"]:
			mouseVector = mouseVector.normalized()*attackData["radius"]
		var attackInstance = _attackScene.instantiate()
		get_parent().add_child(attackInstance)
	
		#print(attackPoint, "attack")
		attackInstance.attack(mouseVector, attackName, self)
	if attackData["type"] == "melee":
		var attackPoint = get_global_mouse_position()
		var attackInstance = _attackScene.instantiate()
		get_parent().add_child(attackInstance)
		attackInstance.attack(attackPoint, attackName, self)
		
func cycleMode(direction):
	_modeInt = (_modeInt+1)%len(_toolList)
	_mode = _toolList[_modeInt]
	print(_mode)
		
func mainInteract():
	if utils.toolsJSON[_mode]["type"] == "weapon":
		attack(utils.toolsJSON[_mode]["attack"])
