extends Node2D

var attackName
@export var playAudio = true

func _ready():
	if playAudio:
		$bgMusic.play()

func play_menu():
	if playAudio:
		$menuSelect.play()

func play_scroll():
	if playAudio:
		$scroll.play()

func play_hit():
	if playAudio:
		$hit.play()

func play_attack(attackName):
	if playAudio:
		get_node(attackName).play()
		
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("muteSfx"):
		playAudio = !playAudio
	
	if Input.is_action_just_pressed("muteBgmusic"):
		$bgMusic.stream_paused = !$bgMusic.stream_paused
