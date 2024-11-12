class_name Bullet
extends RigidBody2D

@export var colorRect: ColorRect

var damage: float
var color: Color:
	set(value):
		color = value
		colorRect.color = color

func _process(_delta):
	if global_position.y < 0 or global_position.y > 540: queue_free()