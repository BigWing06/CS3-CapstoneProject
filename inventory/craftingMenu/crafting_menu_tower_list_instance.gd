extends Control

var _towerPlacementData
var _towerType

func update(tower, towerPlacementData): #This function is to be called by the ready functionn in the crafting menu script
	_towerType = tower
	_towerPlacementData = towerPlacementData
	$HBoxContainer/Control/name.text = _towerPlacementData['name']
	
func selectedTowerUpdate(tower): #This function is to be connected to the selectedTowerChanged signal in the crafting menu scipt, it updates the instance to reflect which tower is being placed
	if tower == _towerType:
		$ColorRect.color = Color(1, 0, 0)
	else:
		$ColorRect.color = Color(0.14, 0.14, 0.14)
	
