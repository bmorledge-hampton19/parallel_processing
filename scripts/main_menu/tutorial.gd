class_name Tutorial
extends Node


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("PRIMARY_MENU_BUTTON"):
		SceneManager.transitionToScene(SceneManager.Scene.MAIN_MENU)
