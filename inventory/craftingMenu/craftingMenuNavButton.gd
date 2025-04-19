extends TextureButton

signal bttnClicked
signal sideBtnClicked(_sender)
@onready var _UIParent = get_node("/root/Main/UIParent")
@export var bttnText:String
@export var ICON_PATH:String
var _normalTexture
func _ready() -> void:
	_normalTexture = self.texture_normal
	_UIParent.sideBtnClicked.connect(_removeActive)
	if ICON_PATH != null:
		$Icon.texture = load(ICON_PATH)
		
func _on_pressed() -> void:
	bttnClicked.emit()
	
func set_active(): # Makes this the active side button
	self.texture_normal = self.texture_focused
	_UIParent.sideBoxClicked(self)
	
func _removeActive(_sender): # Removes the active texture
	if _sender != self:
		self.texture_normal = _normalTexture
