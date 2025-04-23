extends Control

var _activeSectionScene
var _activeSection

@onready var _inventorySubsection = preload("res://inventory/craftingMenu/inventorySubsection/inventorySubsection.tscn")
@onready var _craftingSubsection = preload("res://inventory/craftingMenu/craftingSubsection/craftingSubsection.tscn")

@onready var _inventoryBtn = $margin/VBoxContainer/inventoryButton
@onready var _craftingBtn = $margin/VBoxContainer/craftingButton

@onready var _subsectionContainer = $margin/subsectionContainer

@onready var _sections = {"inventory":_inventorySubsection, "crafting":_craftingSubsection} #This stores the correct subsection scene to instance when the subsection is changed
@onready var _sectionBtns = {"inventory":_inventoryBtn,"crafting":_craftingBtn}
func _ready() -> void:
		_setSection("inventory")
		

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggleInventory"):
		_toggleMenu()
		AudioController.play_menu()
		
func _toggleMenu():
	if !get_parent().get_node("buildMenu").visible:
		visible = !visible
		if visible:
			input.setMouseMode("normal")
		else:
			global.player._hotbar.set_active_tool(global.player._toolList[global.player._modeInt])

func _setSection(section): #Called when a button is clicked to change the subsection 
	if _activeSection != section:
		if  _activeSectionScene != null:
			_activeSectionScene.queue_free()
		_activeSection = section
		_activeSectionScene = _sections[section].instantiate() #Instances the correct subsection for the subsection list
		_subsectionContainer.add_child(_activeSectionScene)
		_sectionBtns[section].set_active() # Sets the clicked section to have an active texture
	
func _on_close_button_bttn_clicked() -> void:
	_toggleMenu()
	AudioController.play_menu()

func _on_inventory_button_bttn_clicked() -> void:
	_setSection("inventory")
	AudioController.play_menu()

func _on_crafting_button_bttn_clicked() -> void:
	_setSection("crafting")
	AudioController.play_menu()
