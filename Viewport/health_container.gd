extends HBoxContainer

@onready var heartScene = preload("res://Player/HealthHeart.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	createHearts(5)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func createHearts(numHearts:int):
	for child in get_children():
		child.queue_free()
	for heart in range(numHearts):
		var currentHeart  = heartScene.instantiate()
		#currentHeart.texture=ResourceLoader.load("res://Player/HalfHeart.png")
		self.add_child(currentHeart)
