extends TextureProgressBar
@onready var _player = get_node("/root/Main/World/Player")
func _ready() -> void:
	_player.connect("healthChanged",_updateValue) #Whent the player's health is changed recreate the health bar
	_updateValue() # Creates the inital player hearts

func _updateValue():
	var _inputHealth = float(_player.getHealth()) # The current player health
	var _maxHealth = float(_player.get_max_health()) # Max health
	self.value = 100 * (_inputHealth/_maxHealth)
