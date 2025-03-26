extends HBoxContainer

@onready var _heartScene = preload("res://Player/HealthHeart.tscn")

# Called when the node enters the scene tree for the first time.sadas
func _ready() -> void:
	#createHearts(20)
	global.player.connect("healthChanged",_createHearts)
	_createHearts()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _createHearts():
	var _inputHealth = global.player.getHealth()
	for child in get_children():
		child.queue_free()
	for heart in range(floori(_inputHealth/2)):
		var _currentHeart  = _heartScene.instantiate()
		self.add_child(_currentHeart)
	if _inputHealth % 2 >0:
		var _currentHeart  = _heartScene.instantiate()
		_currentHeart.texture=ResourceLoader.load("res://Player/HalfHeart.png")
		self.add_child(_currentHeart)
