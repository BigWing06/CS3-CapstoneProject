extends CharacterBody2D

@export var speed = 400
var screen_size
var _health
@export var _STARTING_HEALTH = 20
func _ready():
	screen_size = get_viewport_rect().size
	_health= _STARTING_HEALTH
func _process(delta):
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
	position = position.clamp(Vector2.ZERO, screen_size)
	
func damage(_damage:float): # Funciton to cause damage to player
	_health-=_damage
func heal(_health:float): # Function to heal player
	_health-=_health
