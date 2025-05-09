extends CharacterBody2D

signal chunkChanged
signal healthChanged
signal death
signal mainInteract
signal buildMenu
signal damage
signal toolChanged(_tool)
@onready var _healthChangeScene = preload("res://inventory/health_change.tscn") # The health change animation scene
@onready var _attackScene = preload("res://gameplayReferences/combat/attack.tscn")
@onready var _hotbarScene = preload("res://Hotbar/hotbar.tscn")
@onready var inventory = preload("res://inventory/inventory.gd").new()
@onready var wave = get_parent().get_node("WaveSystem")
@onready var _itemDropScene = preload("res://inventory/droppedItem.tscn")

@onready var toolTimeout = $toolTimeout
@onready var _playerSprite = $playerSprite

@export var speed = 400
@export var _STARTING_HEALTH = 50
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
	inventory.add("hammer", 1)
	_health = _STARTING_HEALTH
	##### Remove these as they are used for test of the gui
	inventory.add("wood", 10)
	inventory.resourcesChanged.connect(global.world.UIParent.get_node("ItemsChanged").itemsChanged)
	death.connect(global.world.UIParent.get_node("PlayerDeath").showDeathScreen) # Connects the death signal to the show death screen function
	_createHotbar()
	for tool in inventory.getToolsList(): #Sets up tool list for tool switching
		_toolList.append(tool)
	_mode = _toolList[0] #Sets the first tool as the default value for the player
	_hotbar.set_active_tool(_toolList[_modeInt]) # Sets the selected hotbar item
	mainInteract.connect(global.world.UIParent.get_node("CenterHUD/ToolCooldown").start) 
	damage.connect(global.world.UIParent.get_node("DamageWarning").play) # Connects the signal to the damage warning animation
	toolChanged.connect(global.world.UIParent.get_node("ControlVisuals/LeftClick").setTool) 
	input.leftClick.connect(func(): mainInteract.emit())
	input.scrollUp.connect(func(): cycleMode(-1))
	input.scrollDown.connect(func(): cycleMode(1))
func getCurrentChunk() -> Vector2i: #Returns the current chunk that the player is in
	return global.world.get_node("TileMaps").getChunk(position)
	
func _createHotbar(): # Creates the hotbar node and sets the items in it into the tools in the inventory
	_hotbar = _hotbarScene.instantiate()
	_hotbar.player=self
	global.world.get_parent().get_node("UIParent/CenterHUD").add_child(_hotbar)
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
		_playerSprite.play("idle")
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
	if Input.is_action_just_pressed("toggleBuildMenu"):
		if _mode != "hammer":
			changeMode("hammer") ### Sets the mode to hammer if build menu is toggled by "e" key, I don't love this but it works for now
		else:
			cycleMode(1)
func healthChange(_amount:float, displayChange = true): # Funciton to cause damage to player
	_health+=_amount
	healthChanged.emit()
	if _amount < 0:
		damage.emit()
		$HealthTimer.start()
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
	var drops = inventory.getResourceDict()
	for drop in drops.keys():
		var dropInstance = _itemDropScene.instantiate()
		global.world.add_child(dropInstance)
		dropInstance.setup(position, drop, ceil(drops[drop]/2))
	inventory.clear()
	healthChange(_STARTING_HEALTH, false)

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
	var _endingMode = _mode # The outgoing mode
	_modeInt = (_modeInt+direction)%len(_toolList)
	_mode = _toolList[_modeInt]
	toolChanged.emit(_mode)
	_hotbar.set_active_tool(_toolList[_modeInt]) # Sets the selected hotbar item
	_checkSignalTool(_endingMode,"scrollEnd") # Checks the current tool for the scrollEnd signal trigger
	_checkSignalTool(_mode,"scrollStart") # Checks the current tool for the scrollStart signal trigger
func changeMode(_newMode): # Changes the tool mode based on string key rather than _intMode
	var _endingMode = _mode # The outgoing mode
	_modeInt = _getToolInt(_newMode)
	_mode = _toolList[_modeInt]
	toolChanged.emit(_mode)
	_hotbar.set_active_tool(_toolList[_modeInt])
	_checkSignalTool(_endingMode,"scrollEnd")
	_checkSignalTool(_mode,"scrollStart")
func _getToolInt(_checkMode):
	return _toolList.find(_checkMode,0)
func _checkSignalTool(_tool, _trigger:String="enter"): # Checks to see if it is a signal tool, if it is emits the signal, also checks to see if it has the correct trigger
	if utils.toolsJSON[_tool]["type"] == "signal":
		if _trigger in utils.toolsJSON[_tool]["trigger"]:
			emit_signal(utils.toolsJSON[_tool]["signal"])
		
func runMainInteract(): #Bound to the left click button and is connected to main tool interactions
	if (toolTimeout.is_stopped()):
		var timeout = utils.readFromJSON(utils.toolsJSON[_mode], "timeout")
		if not timeout:
			timeout = 0
		toolTimeout.wait_time = timeout
		toolTimeout.start()
		var _toolType = utils.toolsJSON[_mode]["type"]
		if _toolType == "weapon":
			attack(utils.toolsJSON[_mode]["attack"])
		if _mode == "stoneAxe":
			var treeMap = global.world.get_node("TileMaps").get_node("Trees")
			var _cursorPos
			var _localPosition = treeMap.local_to_map(treeMap.to_local(round((get_global_mouse_position())/(treeMap.tile_set.tile_size.x*treeMap.scale.x))*treeMap.tile_set.tile_size.x*treeMap.scale.x)) #get position from tile rid
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


func _on_health_timer_timeout() -> void:
	if _health < _STARTING_HEALTH:
		healthChange(1)
