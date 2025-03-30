extends StaticBody2D

@onready var placementZone = $placementZone
@onready var towerRange = $towerRange

var _size:float = 50 #Size of the tower image
var _tower #Stores tower type
var _towerData #Stores date about tower type
var _mode #Determines if the tower is in placement mode ("setup") or if it is placed ("placed")

func setup(tower):
	visible = true #Starts as false and switched to true so that it isn't rendered in incorrect location on creation
	_tower = tower
	_towerData = utils.towerTypesJSON[_tower]
	_mode = "setup"
	$towerIcon.texture = utils.loadImage(utils.towerImageRootPath + _tower + ".png")
	$towerIcon.scale = Vector2(_size/$towerIcon.texture.get_width(), _size/$towerIcon.texture.get_height()) #Calculates scale to match size of the image
	
func _ready() -> void:
	if _mode == "setup": #This is included so that the tower is under the mouse pointer when initially created
		position = get_global_mouse_position()
		$placementZone.body_entered.connect(func(b):updatePlacementCircle())
		$placementZone.body_exited.connect(func(b):updatePlacementCircle())
		global.player.inventory.resourcesChanged.connect(updatePlacementCircle)
		
func build():
	_mode = "placed"
	towerRange.visible = false
	global.player.inventory.resourcesChanged.disconnect(updatePlacementCircle)
	$placementZone.body_entered.disconnect(func(b):updatePlacementCircle())
	$placementZone.body_exited.disconnect(func(b):updatePlacementCircle())
	
	
func _process(delta: float) -> void:
	if _mode == "setup":
		position = get_global_mouse_position()

func checkPlacementArea() -> bool: #Checks to see if the current placement position of the tower is valid returns true if ok
	if(len(placementZone.get_overlapping_bodies())<=1): #Area 2d will always collide with self which is why it must be less than or equal to 1
		return true
	else:
		return false

func checkPlacementResources() -> bool: #Checks to see if the player has the reousrces to build the tower
	if global.player.inventory.hasResourceDict(_towerData["recipe"]):
		return true
	return false

func updatePlacementCircle():
	print("test")
	if checkPlacementArea():
		if checkPlacementResources():
			towerRange.modulate = Color(0, 255, 0)
			return
	
	towerRange.modulate = Color(255, 0, 0)
