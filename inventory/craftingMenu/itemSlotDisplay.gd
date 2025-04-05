extends TextureButton

@onready var hoverTextScene = preload("res://inventory/hoverText.tscn")

var _hoverTextInstance
var _resourceData
var _resource
func display(resource, amount = -2): #Called by the crafting menu script to show a specific resource
	var amountLbl = $amountLbl
	_resource = resource
	_resourceData = utils.resourceJSON[resource]
	if amount != -2:
		amountLbl.visible = true
		amountLbl.text = str(amount)
	else:
		amountLbl.visible = false
	texture_normal = utils.loadImage(utils.appendToPath(utils.resourceImageRootPath, resource + ".png"))
	
func _on_mouse_entered() -> void:
	_hoverTextInstance = hoverTextScene.instantiate()
	_hoverTextInstance.text = _resourceData["name"]
	global.UIParent.add_child(_hoverTextInstance)
func _on_mouse_exited() -> void:
	_hoverTextInstance.queue_free()
