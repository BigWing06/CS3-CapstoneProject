extends Node2D

@onready var enemy = $enemyBody/enemySpr
@onready var base = $base
var enemyData = {}
var speed
var movementType
var target
var startingHealth
var hybrid

var _resourceJSONPath = "res://Enemy/enemyTypes.json"
var _resourceJSONText = FileAccess.get_file_as_string(_resourceJSONPath)
var _resouceJSON = JSON.parse_string(_resourceJSONText)

func _ready():
	enemyData = _resouceJSON
	_update("polar_bear")

func _physics_process(delta):
	enemy.position += (target - enemy.position)/speed #sets a target for enemy to follow
	
func _update(x): #updates enemy variables
	speed = enemyData[x]["speed"]
	movementType = enemyData[x]["movement"]
	startingHealth = enemyData[x]["health"]
	
	if movementType == "baseFocused":
		target = base.position
		hybrid = false
	elif movementType == "playerFocused":
		target = "player" #placeholder for player position
		hybrid = false
	elif movementType == "hybrid":
		hybrid = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if hybrid:
		target = "player"

func _on_area_2d_body_exited(body: Node2D) -> void:
	if hybrid:
		target = base.position
