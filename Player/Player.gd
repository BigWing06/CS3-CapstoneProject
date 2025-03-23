extends CharacterBody2D

@export var speed = 400
var screen_size
var chunk: Vector2i

func _ready():
	screen_size = get_viewport_rect().size

func processMovement(delta: float) -> void: #Proceses the player movement
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
	
func getCurrentChunk() -> Vector2i: #Returns the current chunk that the player is in
	return global.world.get_node("TileMaps").getChunk(position)

func _physics_process(delta: float) -> void:
	processMovement(delta)

func _process(delta):
	chunk = getCurrentChunk()
	global.world.get_node("TileMaps").playerRenderNeighborChunks(getCurrentChunk())
	
