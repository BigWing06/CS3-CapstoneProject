extends Control

@onready var _normalFrame = preload("res://inventory/buildMenu/TowerPlacementAssets/TowerFrame.png")
@onready var _highlightFrame = preload("res://inventory/buildMenu/TowerPlacementAssets/TowerFrame_Selected.png")
var _towerPlacementData
var _towerType

func update(tower, towerPlacementData): #This function is to be called by the ready function in the crafting menu script
	_towerType = tower
	_towerPlacementData = towerPlacementData
	$HBoxContainer/Control/name.text = _towerPlacementData['name']
	$HBoxContainer/towerDisplay.texture = utils.loadImage(utils.appendToPath(utils.towerImageRootPath, _towerType + ".png"))
	self.focus_mode = FOCUS_ALL
	
	
func selectedTowerUpdate(tower): #This function is to be connected to the selectedTowerChanged signal in the crafting menu scipt, it updates the instance to reflect which tower is being placed
	if tower == _towerType:
		$Frame.texture = _highlightFrame
		call_deferred("grab_focus")
	else:
		$Frame.texture = _normalFrame
