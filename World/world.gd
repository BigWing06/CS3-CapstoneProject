extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var inventory = load("res://inventory/inventory.gd").new()
	inventory.add("exampleResource",10)
	print(inventory.getAmount("exampleResource"))
