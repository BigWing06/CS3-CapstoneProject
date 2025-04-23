extends TextureRect

var _tool = ""

func _ready():
	input.UI_Mouse.connect(_showUIMessage)
	setTool(global.player.getMode())

func changeText(_newText):
	$Label.text = str(_newText)
func setTool(_tool:String):
	if len(_tool)>1:
		_tool = utils.toolsJSON[_tool]["verb"]
		changeText(_tool)
func _showUIMessage(_value:bool):
	if _value:
		$Label.text = "Click"
	else:
		$Label.text = _tool
