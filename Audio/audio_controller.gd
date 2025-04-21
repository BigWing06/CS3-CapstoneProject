extends Node2D

var deathToggle = true
@export var playAudio = true

func _ready():
	if playAudio:
		$bgMusic.play()

func play_menu():
	if playAudio:
		$menuSelect.play()

func play_hit():
	if playAudio:
		if deathToggle:
			$hit.play()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("muteSfx"):
		playAudio = !playAudio
	
	if Input.is_action_just_pressed("muteBgmusic"):
		$bgMusic.stream_paused = !$bgMusic.stream_paused
