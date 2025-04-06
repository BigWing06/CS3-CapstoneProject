extends CharacterBody2D

var _enemyData = {} # All JSON data on the enemy types
var _enemyType # The type of enemy
var _speed # The speed at which the enemy moves
var _movementType # The type of movment the enemy has
var _target = Vector2(0, 0)
var _startingHealth
var _hybrid = false
var _player

# Loads in the enemy types #  ###NOTE FOR LATER: Move this when we implement JSON script
var _resourceJSONPath = "res://Enemy/enemyTypes.json"
var _resourceJSONText = FileAccess.get_file_as_string(_resourceJSONPath)
var _resouceJSON = JSON.parse_string(_resourceJSONText)

@onready var _raycast = $AttackRaycast # The raycast object uses to find the fasest path to the player
@onready var _rangedObject = preload("res://Enemy/Attacks/RangedObject.tscn") # The ranged object scene
var _queuedAttack # The next attack to be used
var _nearPlayer = false # If the player is within the attack radius

func _ready():
	_enemyData = utils.enemyJSON
	_update("penguin") #choose animal from json file
	_loadNextAttack() # Loads in the first attack

func _physics_process(delta):
	#changes target and specifies hybrid
	if _movementType == "baseFocused":
		_target = global.basePosition
	elif _movementType == "playerFocused":
		_target = global.player.position
	else:
		_target = global.basePosition
		_hybrid = true 

	position += (_target - position)/_speed #sets a target for enemy to follow
	
func _update(x): #updates enemy variables
	_speed = _enemyData[x]["speed"]
	_movementType = _enemyData[x]["movement"]
	_startingHealth = _enemyData[x]["health"]
	_enemyType = _enemyData[x]
	

		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if _hybrid:
		_movementType = "playerFocused"
func _on_area_2d_body_exited(body: Node2D) -> void:
	if _hybrid:
		_movementType = "baseFocused"


func _attack(_attackData): # The function to attack the player ###Base attacking could be built off of this later
	$AttackCooldown.wait_time = _attackData["cooldown"] # Sets the cooldown timer
	$AttackCooldown.start() # Starts the cooldown timer
	_raycast.target_position = to_local(global.player.position) # Points the raycast towards the player
	if _attackData["type"] == "ranged": # If a ranged attack set up and adopt a projectile instance
		var projectile = _rangedObject.instantiate()
		var _direction = (_raycast.target_position).normalized()
		var _playerPosition = global.player.position
		var _speed = _attackData["speed"]
		var _lifetime = _attackData["lifetime"]
		var _damage = _attackData["damage"]
		var _texture = _attackData["projectileSprite"]
		var _size = Vector2(_attackData["projectileSize"][0],_attackData["projectileSize"][1])
		var _durability = _attackData["durability"]
		projectile.generateProjectile(_direction,_playerPosition,_speed,_lifetime,_texture,_size,_damage,_durability)
		add_child(projectile)
	elif _attackData["type"] == "melee": # If a melee attack, cause the player a set amount of damage
		global.player.damage(_attackData["damage"])
	_loadNextAttack() # Preloads in the next attack

func _loadNextAttack(): # Prepared the next attacks values
	_queuedAttack = global.attackTypes[utils.randWeightedFromDict(_enemyType["attacks"])] # Randomly chooses a weigted attack
	$AttackRadius/CollisionShape2D.shape.radius = _queuedAttack["radius"] # Sets the attack reach ranges
	
func _on_attack_radius_body_entered(body: Node2D) -> void: # When the player enteres the attack area, cause an attack
	_nearPlayer = true
	if $AttackCooldown.is_stopped():
		_attack(_queuedAttack)

func _on_attack_radius_body_exited(body: Node2D) -> void: # If the player leaves the area, then set the _nearPlayer variable
	_nearPlayer = false
	
func _on_attack_cooldown_timeout() -> void: # When the attack has cooled down check to see if near player, and then attack again
	if _nearPlayer:
		_loadNextAttack()
		_attack(_queuedAttack)
