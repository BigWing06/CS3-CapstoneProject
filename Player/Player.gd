extends CharacterBody2D

@export var speed = 400
@onready var inventory = preload("res://inventory/inventory.gd").new()

var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	inventory.add("wood", 100)
	inventory.add("snowball", 100)

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
