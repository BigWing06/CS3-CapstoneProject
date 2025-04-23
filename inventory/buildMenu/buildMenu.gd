extends Control

signal selectedTowerChanged(FOCUS_CLICK)
signal buildMenu
var _towerListScene = preload("res://inventory/buildMenu/buildMenuTowerListInstance.tscn") #Reference to scene for the tower menu list
@onready var _towerDisplayList = $MenuContainer/scrollContainer/towerDisplayList #Stores refence to towerDispalyList node for use later
@onready var _towerInstanceScene = preload("res://Tower/tower.tscn") #Stores a reference to the tower scene that will be instanced
@onready var _towerTypesList = utils.towerTypesJSON.keys() #Gets a list of tower names from the tower types JSON file
@onready var _resourceDisplay = $MenuContainer/Control/resourceDisplay #Reference to the resource display node
@onready var _itemSlotDisplay = preload("res://inventory/craftingMenu/itemSlotDisplay.tscn") #Reference to the itemSlotDisplay scene so that it can be instanced later
@onready var _player = get_node("/root/Main/World/Player")
@onready var _BGTexture = load("res://inventory/buildMenu/TowerPlacementAssets/TowerPlacementBG.png")
@onready var _BGTextureHover = load("res://inventory/buildMenu/TowerPlacementAssets/TowerPlacementBGHover.png")
var _selectedTowerInt = 0 #Integer value that gets changed to represent the tower that is being placed
var _towerInstance = null #Stores the instance copy of the tower scene that is in placing mode

func _ready() -> void:
	input.buildScrollUp.connect(_onScrollUp)
	input.buildScrollDown.connect(_onScrollDown)
	_player.buildMenu.connect(_toggleMenu) # If buildMenu signal is activated _toggleMenu
	set_focus_mode(FOCUS_NONE)
	for key in _towerTypesList: #Instances the craftingMenuTowerListInstance to create the list in the crafting menu
		var towerListSceneInstance = _towerListScene.instantiate()
		towerListSceneInstance.update(key, utils.towerTypesJSON[key])
		selectedTowerChanged.connect(towerListSceneInstance.selectedTowerUpdate)
		_towerDisplayList.add_child(towerListSceneInstance)
	
func _onScrollDown() -> void:
	_selectedTowerInt = (_selectedTowerInt + 1) % len(_towerTypesList) #Adds one to the selectecdTowerInt variable so that the selection can change Note: modulous is used to keep the value within the list bounds
	selectedTowerChanged.emit(_towerTypesList[_selectedTowerInt]) #Signal emited for the craftingMenuTowerListInstance scenes to connect to to change which item is highlighted
	AudioController.play_scroll()

func _onScrollUp() -> void:
	_selectedTowerInt = (_selectedTowerInt - 1) % len(_towerTypesList) #Subtracts one to the selectecdTowerInt variable so that the selection can change Note: modulous is used to keep the value within the list bounds
	selectedTowerChanged.emit(_towerTypesList[_selectedTowerInt]) #Signal emited for the craftingMenuTowerListInstance scenes to connect to to change which item is highlighted
	AudioController.play_scroll()
	
func _build() -> void: #Runs when the left mouse button is clicked and checks to see if the player can built the tower and then builds it
	if _towerInstance.checkPlacementArea(): #Checks to make sure that the position is valid
		if _towerInstance.checkPlacementResources():
			global.player.inventory.addResourceDict(_towerInstance._towerData["recipe"], -1)
			for child in _resourceDisplay.get_children(): # Loops through needed resources and updates frames with inventory values
				var resource = child.get_resource()
				child.display(resource, _towerInstance._towerData["recipe"][resource],global.player.inventory.hasAmount(resource,  _towerInstance._towerData["recipe"][resource]))
				child.set_clickable(false) # Sets the frame outline to the correct texture
			_towerInstance.build()
			_towerInstance = null
			_updatePlacingTower(_towerTypesList[_selectedTowerInt])
			AudioController.play_menu()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggleBuildMenu"):
		if utils.readFromJSON(utils.toolsJSON[_player.getMode()],"signal") != "buildMenu":
			_toggleMenu()

	
func _on_selected_tower_changed(tower: Variant) -> void: #This function is called when the selected tower needs to change. Connected to tower changed signal
	var towerInfo = utils.towerTypesJSON[tower]
	$MenuContainer/Control/towerTitle.text = towerInfo['name']
	$MenuContainer/Control/towerImage.texture = utils.loadImage(utils.towerImageRootPath + tower + '.png')
	for child in _resourceDisplay.get_children(): #Deletes all the children in the required reosurce display container
		child.queue_free()
	for resource in towerInfo["recipe"].keys(): #Anstances the itemSlotDisplay scene to show the required resrouces for the new tower
		var display = _itemSlotDisplay.instantiate()
		display.display(resource, towerInfo["recipe"][resource],global.player.inventory.hasAmount(resource, towerInfo["recipe"][resource]))
		display.custom_minimum_size = Vector2(40, 40)
		_resourceDisplay.add_child(display)
		display.set_clickable(false) # Removes the ability to select the item slot display
	_updatePlacingTower(tower)
		
func _toggleMenu() -> void: #Toggles the menu's visibility
	if !get_parent().get_node("craftingMenu").visible:
		AudioController.play_menu()
		if utils.readFromJSON(utils.toolsJSON[_player.getMode()],"signal") == "buildMenu": # If the build menu tool is in use, make sure menu does not close
			visible = true
		else:
			visible = !visible
		if visible: #Code that runs if the menu is going to be shown
			selectedTowerChanged.emit(_towerTypesList[_selectedTowerInt]) #Emmited to make sure that the highlighted tower matches what is selected
			input.leftClick.connect(_build)
		else: #Code that closes the build menu
			_updatePlacingTower(null)
			input.leftClick.disconnect(_build)

func _updatePlacingTower(tower) -> void: #Updates the tower preview if the type changes
	if _towerInstance != null:
		_towerInstance.queue_free()
	_towerInstance = null
	if tower != null:
		_towerInstance = _towerInstanceScene.instantiate()
		_towerInstance.setup(tower)
		global.world.add_child(_towerInstance)


func _onMouseEnter() -> void:
	input.scrollMode = "build"
	$MenuContainer/TextureRect.texture = _BGTextureHover


func _onMouseExit() -> void:
	input.scrollMode = "normal"
	$MenuContainer/TextureRect.texture = _BGTexture
