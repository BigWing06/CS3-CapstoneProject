extends CharacterBody2D

signal chunkChanged
signal healthChanged
signal death

@onready var _healthChangeScene = preload("res://Player/health_change.tscn") # The health change animation scene

@export var speed = 400
@onready var INVENTORY_SCRIPT = preload("res://inventory/inventory.gd")
@onready var _HEALTH_BAR = preload("res://HealthBar/health_bar.tscn")
@onready var _BUILD_MENU = preload("res://inventory/buildMenu/buildMenu.tscn")
@onready var _CRAFTING_MENU = preload("res://inventory/craftingMenu/craftingMenu.tscn")
var screen_size
var _chunk: Vector2i
var _preChunk: Vector2i = Vector2i(0,0) #Keeps track of the previous chunk the player was in
var _health
var inventory
@export var _STARTING_HEALTH = 20

func _enter_tree() -> void:
	set_multiplayer_authority(int(str(self.name)))

func _ready():
	if not is_multiplayer_authority():
		return
	global.player=self ###
	screen_size = get_viewport_rect().size
	global.world.get_node("TileMaps").playerRenderNeighborChunks(getCurrentChunk())
	_health= _STARTING_HEALTH
	inventory = INVENTORY_SCRIPT.new()
	_buildUI()
	##### Remove these as they are used for test of the gui
	inventory.add("wood", 100)
	inventory.add("snowball", 100)
func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return
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
	if not is_multiplayer_authority():
		return
	if (getCurrentChunk() != _chunk): #Determined if the player has entered a new chunk
		_preChunk = _chunk
		_chunk = getCurrentChunk()
		chunkChanged.emit()
		
func _buildUI():
	var _healthBar = _HEALTH_BAR.instantiate()
	global.main.add_child(_healthBar)
	var _buildMenu = _BUILD_MENU.instantiate()
	global.main.get_node("UIParent").add_child(_buildMenu)
	var _craftingMenu = _CRAFTING_MENU.instantiate()
	global.main.get_node("UIParent").add_child(_craftingMenu)
func getCurrentChunk() -> Vector2i: #Returns the current chunk that the player is in
	return global.world.get_node("TileMaps").getChunk(position)


func damage(_damage:float): # Funciton to cause damage to player
	_health-=_damage
	healthChanged.emit()
	if _health<=0:
		death.emit()
	_displayHealthChange(_damage*-1)
	$DamageAnimation.play("Damage")
func heal(_health:float): # Function to heal player
	_health-=_health
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
