extends CharacterBody2D

var _enemyData = {} # All JSON data on the enemy types
var _enemyType # The type of enemy
var _speed # The speed at which the enemy moves
var _movementType # The type of movment the enemy has
var _target = Vector2(0, 0)
var _hybrid = false
var _player
var _health

signal healthChanged
signal death

@onready var _healthChangeScene = preload("res://inventory/health_change.tscn")

@onready var _attackManager = $attackManager
@onready var _attack = $attack
@onready var _sprite = $enemySpr
@onready var _healthbar = $healthBar

func _ready():
	_update(["penguin", "polarbear", "wolf"].pick_random()) #choose animal from json file
	
func _physics_process(delta):
	#changes target and specifies hybrid
	if _movementType == "baseFocused":
		_target = global.basePosition
	elif _movementType == "playerFocused":
		_target = global.player.position
	else:
		_target = global.basePosition
		_hybrid = true 
	_sprite.look_at(_target)
	velocity = (_target - position).normalized()*_speed/2 #sets a target for enemy to follow
	if velocity.x > 0:
		_sprite.flip_v = false
	elif velocity.x < 0:
		_sprite.flip_v = true
	move_and_slide()
	if velocity.length() > 0:
		_sprite.play("walk")
	
func _update(x): #updates enemy variables
	_enemyType = x
	_enemyData = utils.enemyJSON[_enemyType]
	_sprite.sprite_frames = load(utils.appendToPath(utils.enemyAnimationRootPath, _enemyType+"Animations.tres"))
	_speed = _enemyData["speed"]
	_movementType = _enemyData["movement"]
	_health = _enemyData["health"]
	_healthbar.max_value = _health
	_healthbar.value = _health
	_attackManager._setupAttacks(_enemyData["attack"], ["targetGroup", "player"])

func _on_area_2d_body_entered(body: Node2D) -> void:
	if _hybrid:
		_movementType = "playerFocused"
func _on_area_2d_body_exited(body: Node2D) -> void:
	if _hybrid:
		_movementType = "baseFocused"
		
func healthChange(_amount:float): # Funciton to cause damage to player
	_health+=_amount
	_healthbar.value = _health
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
	var _healthChangeScene = _healthChangeScene.instantiate()
	add_child(_healthChangeScene)
	_healthChangeScene.display(_amount,$HealthChangePoint.position)
	$DamageAnimation.play("Heal")


func _on_death() -> void:
	queue_free()
