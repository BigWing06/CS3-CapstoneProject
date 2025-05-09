extends TextureButton
signal itemSlotClicked(_sender,_groups)

@export var NORMAL_TEXTURE: Texture
@export var HOVER_TEXTURE: Texture
@export var DISABLED_TEXTURE: Texture
@export var ACTIVE_TEXTURE: Texture
enum state {NORMAL, HOVER, DISABLED, ACTIVE}
var _texturesDict
@onready var hoverTextScene = preload("res://inventory/hoverText.tscn")
@onready var _UIParent = get_node("/root/Main/UIParent")
var _hoverTextInstance
var _resourceData
var _resource
var _currentState = state.NORMAL
var function # The function to be called on itemSlot press
func _ready() -> void:
	_UIParent.itemSlotClicked.connect(_removeActive)
func display(resource, amount = -2,hasAmount=true): #Called by the crafting menu script to show a specific resource
	_texturesDict = {state.NORMAL:NORMAL_TEXTURE,state.HOVER:HOVER_TEXTURE,state.DISABLED:DISABLED_TEXTURE,state.ACTIVE:ACTIVE_TEXTURE}
	_changeTexture(state.NORMAL)
	var amountLbl = $amountLbl
	_resource = resource
	_resourceData = utils.resourceJSON[resource]
	if amount != -2:
		amountLbl.visible = true
		amountLbl.text = str(amount)
		if !hasAmount:
				amountLbl.set("theme_override_colors/font_color",Color8(255,255,255))
				amountLbl.set("theme_override_colors/font_outline_color",Color8(186,24,28,255))
				_changeTexture(state.DISABLED)
				
		if !hasAmount:
				amountLbl.set("theme_override_colors/font_color",Color8(255,255,255))
				amountLbl.set("theme_override_colors/font_outline_color",Color8(186,24,28,255))
				_changeTexture(state.DISABLED)
				
	else:
		amountLbl.visible = false
	$Frame.texture = utils.loadImage(utils.appendToPath(utils.resourceImageRootPath, resource + ".png"))
	
func _changeTexture(_newState:state,_updateState:bool=true):
	self.texture_normal = _texturesDict[_newState]
	self.texture_disabled = _texturesDict[_newState]
	if _updateState:
		_currentState = _newState
func _revertState():
	_changeTexture(_currentState)

func _on_mouse_entered() -> void:
	input.toggleUIState(true)
	_hoverTextInstance = hoverTextScene.instantiate()
	_hoverTextInstance.text = _resourceData["name"] + " ("+str(global.player.inventory.getAmount(_resource))+")"
	_UIParent.add_child(_hoverTextInstance)
	_changeTexture(state.HOVER,false)

	_hoverTextInstance.text = _resourceData["name"] + " ("+str(global.player.inventory.getAmount(_resource))+")"
	_UIParent.add_child(_hoverTextInstance)
	_changeTexture(state.HOVER,false)

func _on_mouse_exited() -> void:
	input.toggleUIState(false)
	_hoverTextInstance.queue_free()
	_revertState()
func set_clickable(_clickMode:bool = true, _function=null) -> void:  # Removes the ability to select the item, also has the ability to add a clickable function bind
	if _clickMode:
		self.focus_mode=Control.FOCUS_ALL
		function = _function
	else:
		self.focus_mode=Control.FOCUS_NONE
		self.disabled = true
		
func _on_pressed() -> void:
	set_active()
	AudioController.play_menu()
	if function:
		function.call()
	
func set_active() -> void: # Sets this button as the selected item slot
	_changeTexture(state.ACTIVE)
	get_node("/root/Main/UIParent").clickItemSlot(self,self.get_groups())
	
func _removeActive(_sender,_groups): # Removes the active texture
	var _inGroups = false
	for group in _groups:
		if group in  self.get_groups():
			_inGroups=true
	if _sender != self and _inGroups:
		_changeTexture(state.NORMAL)

func get_resource(): # Returns the item slot's resource
	return _resource
