extends HBoxContainer

var _FULL_HEART_TEXTURE = load("res://HealthBar/FullHeart.png")
var _HALF_HEART_TEXTURE = load("res://HealthBar/HalfHeart.png")
@onready var _player = get_node("/root/Main/World/Player")
func _ready() -> void:
	_player.connect("healthChanged",_createHearts) #Whent the player's health is changed recreate the health bar
	_createHearts() # Creates the inital player hearts

func _createHearts():
	var _inputHealth = _player.getHealth() # The current player health
	
	for child in get_children(): # Remove all current children
		child.queue_free()
		
	for heart in range(floori(_inputHealth/2)): # Create a new full heart for all health (divided by two) rounded down
		var _currentHeart = _newHeart()
		_currentHeart.texture = _FULL_HEART_TEXTURE
		add_child(_currentHeart)
		
	if _inputHealth % 2 >0: # For any left over health create a half a heart
		var _currentHeart = _newHeart()
		_currentHeart.texture = _HALF_HEART_TEXTURE
		add_child(_currentHeart)



func _newHeart(): # Create a return a TextureRect with all the correct parameters
	var _heart = TextureRect.new()
	_heart.expand_mode = TextureRect.EXPAND_FIT_HEIGHT_PROPORTIONAL
	_heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	_heart.custom_minimum_size = Vector2(25,25)
	return _heart
