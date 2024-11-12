class_name RealTree
extends Area2D

@export var sprite: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func chop():
	set_collision_layer_value(2, false)
	sprite.region_rect.position = Vector2(64,0)