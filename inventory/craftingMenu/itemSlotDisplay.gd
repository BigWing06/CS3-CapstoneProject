extends TextureButton

@onready var hoverTextScene = preload("res://inventory/hoverText.tscn")
var FRAME_RED = "res://inventory/craftingMenu/InventoryTextures/InventoryFrameLarge_Disabled.png"
var _hoverTextInstance
var _resourceData
var _resource
func display(resource, amount = -2,hasAmount=true): #Called by the crafting menu script to show a specific resource
	var amountLbl = $amountLbl
	_resource = resource
	_resourceData = utils.resourceJSON[resource]
	if amount != -2:
		amountLbl.visible = true
		amountLbl.text = str(amount)
		if hasAmount:
				amountLbl.set("theme_override_colors/font_color",Color8(255,255,255))
				amountLbl.set("theme_override_colors/font_outline_color",Color8(186,24,28,255))
				self.texture_normal = load(FRAME_RED)
	else:
		amountLbl.visible = false
	$Frame.texture = utils.loadImage(utils.appendToPath(utils.resourceImageRootPath, resource + ".png"))
	
	
func _on_mouse_entered() -> void:
	_hoverTextInstance = hoverTextScene.instantiate()
	_hoverTextInstance.text = _resourceData["name"] + " ("+str(global.player.inventory.getAmount(_resource))+")"
	global.UIParent.add_child(_hoverTextInstance)
func _on_mouse_exited() -> void:
	_hoverTextInstance.queue_free()
