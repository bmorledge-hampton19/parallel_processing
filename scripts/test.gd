extends Node

@export var squares: Array[ColorRect]

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(16):
		squares[i].color = PlayerManager.playerColors.values()[i]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
