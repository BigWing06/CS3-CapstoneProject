extends StaticBody2D

@onready var placementZone = $placementZone
@onready var towerRange = $towerRange
@onready var healthBar = $healthBar

@onready var greenTowerCircle = preload("res://Tower/towerPlacementGreen.png")
@onready var redTowerCircle = preload("res://Tower/towerPlacementRed.png")

@onready var _player = get_node("/root/Main/World/Player")
@onready var attackManagerScene = preload("res://gameplayReferences/combat/attackManager.tscn")

var _size:float = 32 #Size of the tower image
var _tower #Stores tower type
var _towerData #Stores data about tower type
var _mode #Determines if the tower is in placement mode ("setup") or if it is placed ("placed")
var _STARTINGHEALTH = 100
var _health = _STARTINGHEALTH

signal healthChanged
signal death
signal targetChanged

func setup(tower):
	visible = true #Starts as false and switched to true so that it isn't rendered in incorrect location on creation
	_tower = tower
	_towerData = utils.towerTypesJSON[_tower]
	_mode = "setup"
	$towerIcon.texture = utils.loadImage(utils.towerImageRootPath + _tower + ".png")
	if utils.readFromJSON(_towerData,"placementMode") == "grid":
		$towerIcon.scale = Vector2(1,1)
		$placementZone/CollisionShape2D.shape.radius = ((_size-5)/2)
	else:
		$towerIcon.scale = Vector2(2,2)
		$placementZone/CollisionShape2D.shape.radius = ((_size-5)/2)*2
	
	
func _ready() -> void:
	if _mode == "setup": #This is included so that the tower is under the mouse pointer when initially created
		position = get_global_mouse_position()
		$placementZone.body_entered.connect(func(b):updatePlacementCircle()) #Connects the updatePlacementCircle() method to the entering of a body in the placementZone area so that the placement is checked when the bodies it is in collision with changes. Note: updatePlacementCircle is visual only and is used to change the color of the placement range so that the use knows if they can place it there
		$placementZone.body_exited.connect(func(b):updatePlacementCircle()) #Connects the updatePlacementCircle() method to the exiting of a body in the placementZone area so that the placement is checked when the bodies it is in collision with changes. Note: updatePlacementCircle is visual only and is used to change the color of the placement range so that the use knows if they can place it there
		_player.inventory.resourcesChanged.connect(updatePlacementCircle)
		updatePlacementCircle()
		
func build():
	_mode = "placed"
	towerRange.visible = false
	_player.inventory.resourcesChanged.disconnect(updatePlacementCircle)
	$placementZone.body_entered.disconnect(func(b):updatePlacementCircle())
	$placementZone.body_exited.disconnect(func(b):updatePlacementCircle())
	if utils.readFromJSON(_towerData, "attack"):
		var attackManager = attackManagerScene.instantiate()
		add_child(attackManager)
		attackManager._setupAttacks(_towerData["attack"], ["enemy"])
	set_collision_layer_value(6, true)
	
	
func _process(delta: float) -> void:
	if _mode == "setup":
		if utils.readFromJSON(_towerData, "placementMode") == "grid": #Checks to see if the tower needs to be locked to the tilemap
			var tileMap = global.world.get_node("TileMaps").getMainTilemap()
			var tileMapCellSize = tileMap.tile_set.tile_size.x
			position = tileMap.local_to_map(get_global_mouse_position())*tileMapCellSize+Vector2i(tileMapCellSize/2, tileMapCellSize/2)
		else:
			position = get_global_mouse_position()

func checkPlacementArea() -> bool: #Checks to see if the current placement position of the tower is valid returns true if ok
	return (len(placementZone.get_overlapping_bodies())==0) #Area 2d will always collide with self which is why it must be less than or equal to 1

func checkPlacementResources() -> bool: #Checks to see if the player has the resources to build the tower
	return _player.inventory.hasResourceDict(_towerData["recipe"])

func updatePlacementCircle(): #Changes the color of the placement circle so that the player can know if the current placement is valid
	if checkPlacementArea():
		if checkPlacementResources():
			towerRange.texture = greenTowerCircle
			return
	towerRange.texture = redTowerCircle
	
func _getNewTarget(): #Used for getting the target of the enemy
	return utils.getClosestNode(self, get_tree().get_nodes_in_group("enemy"))

func getTarget():
	return _getNewTarget()

func healthChange(_amount:float, displayChange = true): # Funciton to cause damage to player
	_health+=_amount
	healthChanged.emit()
	if _amount < 0:
		if _health<=0:
			death.emit()

func _on_health_changed() -> void:
	if _health != _STARTINGHEALTH:
		healthBar.visible = true
	healthBar.value = _health

func _on_death() -> void:
	queue_free()
