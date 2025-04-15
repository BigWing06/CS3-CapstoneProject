extends Node

#This script is to be used to handle keyboard and mouse events by emiting signals

signal scrollUp
signal scrollDown
signal leftClick
signal rightClick
signal interact

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("scrollUp"):
		scrollUp.emit()
	if Input.is_action_just_pressed("scrollDown"):
		scrollDown.emit()
	if Input.is_action_just_pressed("leftClick"):
		leftClick.emit()
	if Input.is_action_just_pressed("rightClick"):
		rightClick.emit()
