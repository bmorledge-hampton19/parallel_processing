extends Node

enum Scene {
	MAIN_MENU,
	TUTORIAL,
	STORY,
	MAIN_SCENE,
	GAME_OVER,
	VICTORY
}

func transitionToScene(scene: Scene):
	match scene:
		Scene.MAIN_MENU:
			get_tree().change_scene_to_file("res://scenes/main_scenes/main_menu.tscn")
		Scene.TUTORIAL:
			get_tree().change_scene_to_file("res://scenes/main_scenes/tutorial.tscn")
		Scene.STORY:
			get_tree().change_scene_to_file("res://scenes/main_scenes/story.tscn")
		Scene.MAIN_SCENE:
			get_tree().change_scene_to_file("res://scenes/main_scenes/main_game.tscn")
		Scene.GAME_OVER:
			get_tree().change_scene_to_file("res://scenes/main_scenes/game_over.tscn")
		Scene.VICTORY:
			get_tree().change_scene_to_file("res://scenes/main_scenes/victory.tscn")