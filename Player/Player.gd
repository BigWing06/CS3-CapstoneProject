extends CharacterBody2D

signal chunkChanged
signal healthChanged
signal death
signal mainInteract
@onready var _healthChangeScene = preload("res://inventory/health_change.tscn") # The health change animation scene
@onready var _attackScene = preload("res://gameplayReferences/combat/attack.tscn")
@onready var _hotbarScene = preload("res://Hotbar/hotbar.tscn")
@onready var inventory = preload("res://inventory/inventory.gd").new()
@onready var wave = get_parent().get_node("WaveSystem")

@onready var toolTimeout = $toolTimeout
@onready var _playerSprite = $playerSprite

@export var speed = 400
@export var _STARTING_HEALTH = 20
var screen_size
var _chunk: Vector2i
var _preChunk: Vector2i = Vector2i(0,0) #Keeps track of the previous chunk the player was in
var _health = 0
var _enemySpawnDistance = 500 #Sets how far away from the player enemies will spawn
var _toolList = [] #Stores the list of tools the player has in inventory
var _mode #String value of selected tool
var _modeInt = 0 #Index of selcted tool in toollist
var _hotbar
var _collision

func _ready():
	global.player = self
	global.world.gameover.connect(queue_free)
	screen_size = get_viewport_rect().size
	$playerSprite.sprite_frames = ResourceLoader.load("res://Player/playerAnimation.tres")
	global.world.get_node("TileMaps").playerRenderNeighborChunks(getCurrentChunk())
	healthChange(_STARTING_HEALTH, false)
	inventory.add("stoneSword", 1)
	inventory.add("bow", 1)
	inventory.add("stoneAxe", 1)
	_health = _STARTING_HEALTH
	##### Remove these as they are used for test of the gui
	inventory.add("chipsWood", 100)
	inventory.add("wood", 100)
	inventory.add("snowball", 100)
	inventory.resourcesChanged.connect(global.world.UIParent.get_node("ItemsChanged").itemsChanged)
	_createHotbar()
	for tool in inventory.getToolsList(): #Sets up tool list for tool switching
		_toolList.append(tool)
	_mode = _toolList[0] #Sets the first tool as the default value for the player
	_hotbar.set_active_tool(_toolList[_modeInt]) # Sets the selected hotbar item
	mainInteract.connect(global.world.UIParent.get_node("StatusBars/ToolCooldown").start)
	input.leftClick.connect(func(): mainInteract.emit())
	input.scrollUp.connect(func(): cycleMode(1))
	input.scrollDown.connect(func(): cycleMode(-1))
	
func getCurrentChunk() -> Vector2i: #Returns the current chunk that the player is in
	return global.world.get_node("TileMaps").getChunk(position)
	
func _createHotbar(): # Creates the hotbar node and sets the items in it into the tools in the inventory
	_hotbar = _hotbarScene.instantiate()
	global.world.get_parent().get_node("UIParent/StatusBars").add_child(_hotbar)
	var _hotbarList = []
	for tool in inventory.getToolsList():
		_hotbarList.append({"name":tool,"amount":inventory.getAmount(tool)})
	_hotbar.update(_hotbarList)
	
func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
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
		_playerSprite.play("walk")
	else:
		_playerSprite.stop()
	if velocity.x > 0:
		_playerSprite.flip_h = false
	elif velocity.x < 0:
		_playerSprite.flip_h = true
	_collision = move_and_slide()

func _process(delta):
	if (getCurrentChunk() != _chunk): #Determined if the player has entered a new chunk
		_preChunk = _chunk
		_chunk = getCurrentChunk()
		chunkChanged.emit()
		
func healthChange(_amount:float, displayChange = true): # Funciton to cause damage to player
	_health+=_amount
	healthChanged.emit()
	if _amount < 0:
		if _health<=0:
			death.emit()
		if displayChange:
			_displayHealthChange(_amount)
			AudioController.play_hit()
			$DamageAnimation.play("Damage")
	elif _amount > 0:
		if displayChange:
			_displayHealthChange(_amount)

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
	position = Vector2.ZERO
	inventory.clear()
	healthChange(_STARTING_HEALTH, false)
	AudioController.deathToggle = false

func _on_reach_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	global.player_entered.emit(body_rid, body.name)

func _spawnEnemyPlayer():
	global.waveSystem.spawnEnemy(utils.getRandomRadiusPosition(position, _enemySpawnDistance))
	
func attack(attackName): #calls and handles player attacks
	var attackData = utils.attackJSON[attackName]
	var attackPoint = get_local_mouse_position()
	if attackPoint.length() > attackData["radius"]:
		attackPoint = attackPoint.normalized()*attackData["radius"]
	var attackInstance = _attackScene.instantiate()
	get_parent().add_child(attackInstance)
	attackInstance.attack(attackPoint, attackName, self, null, ["enemy"])
	
func cycleMode(direction): #Increaments throught the tools avaliable to the player when they scroll
	_modeInt = (_modeInt+direction)%len(_toolList)
	_mode = _toolList[_modeInt]
	_hotbar.set_active_tool(_toolList[_modeInt]) # Sets the selected hotbar item
func runMainInteract(): #Bound to the left click button and is connected to main tool interactions
	if (toolTimeout.is_stopped()):
		var timeout = utils.readFromJSON(utils.toolsJSON[_mode], "timeout")
		if not timeout:
			timeout = 0
		toolTimeout.wait_time = timeout
		toolTimeout.start()
		if utils.toolsJSON[_mode]["type"] == "weapon":
			attack(utils.toolsJSON[_mode]["attack"])
		if _mode == "stoneAxe":
			var treeMap = global.world.get_node("TileMaps").get_node("Trees")
			var _localPosition = treeMap.local_to_map(treeMap.to_local(get_global_mouse_position())) #get position from tile rid
			var _cell = treeMap.get_cell_tile_data(_localPosition)
			if _cell:
				var _resource = (_cell.get_custom_data("resource_given")) #recives the type from custom data from tile date
				treeMap.set_cell(_localPosition, -1) #essentialy makes tile invisible
				inventory.add(_resource, randf_range(1,5)) #adds to inventory 

func _on_tool_timeout_timeout() -> void:
	toolTimeout.stop()
func getMode():
	return _mode
func get_max_health(): # Returns the player's max health
	return _STARTING_HEALTH
