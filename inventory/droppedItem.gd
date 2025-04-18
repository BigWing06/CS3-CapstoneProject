extends CharacterBody2D

@onready var _amountLbl = $amountLbl
@onready var _itemTexture = $itemTexture

var _resource
var _amount

func _ready() -> void:
	setup("chipsWood", 1)

func setup(resource, amount=1):
	_resource = resource
	_amount = amount
	if _amount == 1:
		_amountLbl.visible = false
	else:
		_amountLbl.text = _amount
	_itemTexture.texture = utils.loadImage(utils.appendToPath(utils.resourceImageRootPath, _resource + ".png"))

func _physics_process(delta: float) -> void:
	move_and_slide()

func _on_pickup_region_body_entered(body: Node2D) -> void:
	body.inventory.add(_resource, _amount)
	queue_free()
