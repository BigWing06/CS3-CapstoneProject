extends CharacterBody2D

signal chunkChanged
signal healthChanged
signal death

@onready var _healthChangeScene = preload("res://Player/health_change.tscn") # The health change animation scene

@export var speed = 400
@onready var inventory = preload("res://inventory/inventory.gd").new()

var screen_size
var _chunk: Vector2i
var _preChunk: Vector2i = Vector2i(0,0) #Keeps track of the previous chunk the player was in
var _health
@export var _STARTING_HEALTH = 20
func _ready():
	screen_size = get_viewport_rect().size
	global.world.get_node("TileMaps").playerRenderNeighborChunks(getCurrentChunk())
	_health= _STARTING_HEALTH
	
	##### Remove these as they are used for test of the gui
	inventory.add("wood", 100)
	inventory.add("snowball", 100)
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
