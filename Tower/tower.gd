extends CharacterBody2D

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
		
func build():
	_mode = "placed"
	
func _process(delta: float) -> void:
	if _mode == "setup":
		position = get_global_mouse_position()
