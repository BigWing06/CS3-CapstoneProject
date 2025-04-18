extends TextureButton

signal bttnClicked
signal sideBoxClicked(_sender)
@export var bttnText:String
@export var ICON_PATH:String
var _normalTexture
func _ready() -> void:
	_normalTexture = self.texture_normal
	self.connect("bttnClicked",Callable(_removeActive).bind(self))
	if ICON_PATH != null:
		$Icon.texture = load(ICON_PATH)
func _on_pressed() -> void:
	self.texture_normal = self.texture_focused
	bttnClicked.emit()
	sideBoxClicked.emit()
func _removeActive(_sender):
	print("Sender "+str(_sender)+" Self "+str(self))
	if _sender != self:
		print("!!!!!!!!!!!!")
		self.texture_normal = _normalTexture
