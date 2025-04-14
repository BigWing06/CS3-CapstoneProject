extends Control

var _activeSectionScene
var _activeSection

@onready var _inventorySubsection = preload("res://inventory/craftingMenu/inventorySubsection/inventorySubsection.tscn")
@onready var _craftingSubsection = preload("res://inventory/craftingMenu/craftingSubsection/craftingSubsection.tscn")

@onready var _subsectionContainer = $margin/subsectionContainer

@onready var _sections = {"inventory":_inventorySubsection, "crafting":_craftingSubsection} #This stores the correct subsection scene to instance when the subsection is changed

func _ready() -> void:
		_setSection("inventory")
		

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggleInventory"):
		_toggleMenu()
		
func _toggleMenu():
	visible = !visible

func _setSection(section): #Called when a button is clicked to change the subsection 
	if _activeSection != section:
		if  _activeSectionScene != null:
			_activeSectionScene.queue_free()
		_activeSection = section
		_activeSectionScene = _sections[section].instantiate() #Instances the correct subsection for the subsection list
		_subsectionContainer.add_child(_activeSectionScene)
	
func _on_close_button_bttn_clicked() -> void:
	_toggleMenu()

func _on_inventory_button_bttn_clicked() -> void:
	_setSection("inventory")

func _on_crafting_button_bttn_clicked() -> void:
	_setSection("crafting")
