extends CharacterBody2D

var _tower #Stores tower type
var _towerData #Stores date about tower type
var _mode #Determines if the tower is in placement mode ("setup") or if it is placed ("placed")

func setup(tower):
	visible = true #Starts as false and switched to true so that it isn't rendered in incorrect location on creation
	_tower = tower
	_towerData = utils._towerTypesJSON[_tower]
	_mode = "setup"
	
func _ready() -> void:
	if _mode == "setup": #This is included so that the tower is under the mouse pointer when initially created
		position = get_global_mouse_position()
		
func build():
	_mode = "placed"
	
func _process(delta: float) -> void:
	if _mode == "setup":
		position = get_global_mouse_position()
